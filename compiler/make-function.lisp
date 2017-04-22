(in-package :varjo)
(in-readtable :fn.reader)

;;============================================================
;; The mess of creation

(defmethod build-external-function ((func external-function) env)
  (with-slots (name in-args uniforms code glsl-versions) func
    (vbind (compiled-func maybe-def-code)
        (build-function name
                        (append in-args
                                (when uniforms `(&uniform ,@uniforms)))
                        code
                        nil
                        env)
      ;; Here we check that we haven't got any behaviour that, while legal for
      ;; main or local funcs, would be undesired in external functions
      (when maybe-def-code
        (assert (= (length (return-set maybe-def-code)) 0))
        ;; (assert (= (length (emit-set maybe-def-code)) 0))
        (assert (null (current-line maybe-def-code)))
        (assert (null (flow-ids maybe-def-code)))
        (assert (null (multi-vals maybe-def-code)))
        (assert (null (out-of-scope-args maybe-def-code)))
        (assert (null (place-tree maybe-def-code)))
        (assert (null (to-block maybe-def-code)))
        (assert (typep (primary-type maybe-def-code) 'v-none)))
      (values compiled-func maybe-def-code))))

(defun build-function (name args body allowed-implicit-args env)
  ;;
  ;; Check that the args are correctly formatted, we could just let
  ;; type-spec->type take care of this, however this way we get to
  ;; give better error messages (and also impose extra limitations
  (unless (function-raw-args-validp args)
    (error 'bad-make-function-args
           :func-name name
           :arg-specs (remove-if #'function-raw-arg-validp args)))
  ;;
  ;; Parse the types
  (let* ((arg-types (mapcar λ(type-spec->type (second _)) args))
         (args-with-types (mapcar λ(dbind (name nil . rest) _
                                     `(,name ,_1 ,@rest))
                                  args
                                  arg-types)))
    (if (some λ(typep _ 'v-unrepresentable-value) arg-types)
        (make-new-function-with-unreps
         name args body allowed-implicit-args env)
        (make-regular-function
         name args-with-types body allowed-implicit-args env))))


(defun make-regular-function (name args body allowed-implicit-args env)
  (vbind (body declarations) (extract-declares body)
    (let* ((mainp (eq name :main))
           (func-env (make-func-env env mainp allowed-implicit-args))
           (in-arg-flow-ids (mapcar (lambda (_)
                                      (declare (ignore _))
                                      (flow-id!))
                                    args))
           (arg-glsl-names (loop :for (name) :in args :collect
                              (lisp-name->glsl-name name env)))
           (body-env (add-declarations-to-env
                      declarations
                      (reduce
                       (lambda (func-env tripple)
                         (dbind (arg glsl-name flow-ids) tripple
                           (dbind (name type) arg
                             (add-symbol-binding
                              name
                              (v-make-value
                               (set-flow-id type flow-ids)
                               func-env
                               :glsl-name glsl-name)
                              func-env))))
                       (mapcar #'list args arg-glsl-names in-arg-flow-ids)
                       :initial-value (if mainp
                                          func-env
                                          (remove-main-method-flag-from-env
                                           func-env)))))
           (body-obj (compile-form `(implicit-return (progn ,@body)) body-env))
           (implicit-args (extract-implicit-args name allowed-implicit-args
                                                 (normalize-out-of-scope-args
                                                  (out-of-scope-args body-obj))
                                                 func-env))
           (glsl-name (if mainp "main" (lisp-name->glsl-name name func-env)))
           (return-set (map 'list #'identity (return-set body-obj)))
           (emit-set (emit-set body-obj))
           (primary-type (or (when return-set (v-type-of (first return-set)))
                             (type-spec->type :void)))
           (multi-return-vars (when return-set (rest return-set)))
           (type (if mainp (type-spec->type 'v-void) primary-type)))
      (when (v-typep type (gen-none-type))
        (error 'function-with-no-return-type :func-name name))
      (let* ((arg-pairs (unless mainp
                          (loop :for (nil type) :in args
                             :for name :in arg-glsl-names :collect
                             `(,(v-glsl-string type) ,name))))
             (out-arg-pairs (unless mainp
                              (loop :for mval :in multi-return-vars
                                 :for i :from 1
                                 :for name = (glsl-name mval)
                                 :for type = (v-glsl-string (v-type-of mval))
                                 :collect `(,type ,name))))
             (in-out-args
              ;; {TODO} handle multiple returns
              (when (and (typep type 'v-function-type)
                         (ctv type)
                         (implicit-args (ctv type)))
                (let ((closure (ctv type)))
                  (append (in-out-args closure)
                          (implicit-args closure)))))
             (return-for-glsl (if (ephemeral-p type)
                                  (type-spec->type :void)
                                  type))
             (strip-glsl
              (and (not mainp)
                   (pure-p body-obj)
                   (or (v-typep type 'v-void) (ephemeral-p type))
                   (null multi-return-vars)))
             (sigs (unless (or mainp strip-glsl)
                     (list (gen-function-signature glsl-name arg-pairs
                                                   out-arg-pairs
                                                   return-for-glsl
                                                   implicit-args
                                                   in-out-args))))
             (func-glsl-def (unless strip-glsl
                              (gen-function-body-string
                               glsl-name arg-pairs
                               out-arg-pairs
                               return-for-glsl body-obj
                               implicit-args in-out-args)))
             (arg-types (mapcar #'second args))
             (func (make-user-function-obj name
                                           (unless strip-glsl
                                             (gen-function-transform
                                              glsl-name args
                                              multi-return-vars
                                              implicit-args))
                                           nil ;;{TODO} should be context
                                           arg-types
                                           (cons type multi-return-vars)
                                           :glsl-name glsl-name
                                           :implicit-args implicit-args
                                           :in-out-args in-out-args
                                           :flow-ids (flow-ids body-obj)
                                           :in-arg-flow-ids in-arg-flow-ids
                                           :pure (pure-p body-obj)))
             (ret-set (return-set body-obj))
             (tl-meta (hash-table-values (slot-value body-env 'local-metadata)))
             (code-obj (copy-code body-obj
                                  :type (gen-none-type)
                                  :current-line nil
                                  :to-block nil
                                  :return-set nil
                                  :emit-set emit-set
                                  :multi-vals nil
                                  :place-tree nil
                                  :out-of-scope-args implicit-args))
             (ast (to-top-level-ast-node body-obj declarations body-env)))
        (values (make-instance 'compiled-function-result
                               :function-obj func
                               :signatures sigs
                               :ast ast
                               :used-types (used-types code-obj)
                               :glsl-code func-glsl-def
                               :stemcells (stemcells code-obj)
                               :return-set ret-set
                               :emit-set emit-set
                               :top-level-scoped-metadata tl-meta)
                code-obj)))))

(defun to-top-level-ast-node (body-obj declarations env)
  (let* ((ast (node-tree body-obj))
         (ast-args (ast-args ast))
         (decl-nodes (mapcar λ(make-ast-node-for-declaration _ env)
                             declarations)))
    (if (eq 'progn (ast-kind ast))
        (copy-ast-node ast :kind :function-top-level
                       :args (append decl-nodes ast-args))
        (ast-node! :function-top-level
                   `(,@decl-nodes ,@ast-args)
                   (ast-return-type (last1 ast-args))
                   env env))))

(defun make-new-function-with-unreps (name args body allowed-implicit-args
                                      env)
  (let ((mainp (eq name :main)))
    (assert (not (eq name :main)))
    (let* ((func-env (make-func-env env mainp allowed-implicit-args))
           (all-vars (env-binding-names env :stop-at-base t
                                        :variables-only t))
           (visible-vars (remove-if-not λ(get-symbol-binding _ t env)
                                        all-vars))
           (visible-var-pairs (mapcar λ(capture-var _ env) visible-vars))
           (arg-types (mapcar (lambda (x) (type-spec->type (second x))) args))
           (func (make-user-function-obj name nil nil arg-types nil
                                         :code (list args body)
                                         :captured-vars visible-var-pairs))
           (ast-body (if (= 1 (length body))
                         (first body)
                         `(progn ,@body)))
           (ast (ast-node! :code-section
                           ast-body
                           (gen-none-type)
                           func-env func-env)))
      (values (make-instance 'compiled-function-result
                             :function-obj func
                             :signatures nil
                             :ast ast
                             :used-types nil
                             :glsl-code nil
                             :stemcells nil
                             :return-set nil
                             :emit-set nil)
              (code! :type (gen-none-type)
                     :current-line nil
                     :place-tree nil
                     :node-tree (ast-node! :code-section
                                           ast-body
                                           (gen-none-type)
                                           func-env func-env))))))

(defun capture-var (name env)
  (let ((val (get-symbol-binding name t env)))
    (assert (typep val 'v-value))
    (make-instance 'captured-var
                   :name name
                   :value val
                   :origin-env env)))

(defun function-raw-args-validp (raw-args)
  (every #'function-raw-arg-validp raw-args))

(defun function-raw-arg-validp (raw-arg)
  "Basic checks to validate the argument forms for the function"
  (and (listp raw-arg)
       (>= (length raw-arg) 2)
       (not (null (first raw-arg)))
       (symbolp (first raw-arg))
       (not (keywordp (first raw-arg)))
       (type-specp (second raw-arg))))

(defun extract-implicit-args (name allowed-implicit-args
                              normalized-out-of-scope-args env)
  (let ((result (remove-if λ(= (v-function-scope _)
                               (v-function-scope env))
                           normalized-out-of-scope-args)))
    (if (or (eq allowed-implicit-args t)
            (and (listp allowed-implicit-args)
                 (every λ(member _ allowed-implicit-args)
                        allowed-implicit-args)))
        result
        (when result
          (error 'illegal-implicit-args :func-name name)))))

(defun make-func-env (env mainp allowed-implicit-args)
  (if mainp
      (fresh-environment env :function-scope (1+ (v-function-scope env))
                         :context (cons :main (v-context env))
                         :allowed-outer-vars allowed-implicit-args)
      (fresh-environment env :function-scope (1+ (v-function-scope env))
                         :allowed-outer-vars allowed-implicit-args)))
