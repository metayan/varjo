(in-package :vari.cl)

;;------------------------------------------------------------

(v-def-glsl-template-fun symbolp (a) "false" (v-type) v-bool)
(v-def-glsl-template-fun keywordp (a) "false" (v-type) v-bool)
(v-def-glsl-template-fun vectorp (a) "true" (v-array) v-bool)
(v-def-glsl-template-fun array-rank (a) "1" (v-array) v-int)
(v-def-glsl-template-fun array-row-major-index (a i) "~a" (v-array v-int) v-int)

(v-def-glsl-template-fun adjustable-array-p (a) "false" (v-array) v-bool)
(v-def-glsl-template-fun array-has-fill-pointer-p (a) "false" (v-array) v-bool)

(v-def-glsl-template-fun bit-vector-p (a) "false" (v-array) v-bool)
(v-def-glsl-template-fun compiled-function-p (a) "true" (v-function-type) v-bool)


(v-def-glsl-template-fun 1+ (a) "(~a + 1)" (v-real) 0 :pure t)
(v-def-glsl-template-fun 1+ (a) "(~a + 1)" (v-vector) 0 :pure t)
(v-def-glsl-template-fun 1+ (a) "(~a + 1)" (v-matrix) 0 :pure t)
(v-def-glsl-template-fun 1- (a) "(~a - 1)" (v-real) 0 :pure t)
(v-def-glsl-template-fun 1- (a) "(~a - 1)" (v-vector) 0 :pure t)
(v-def-glsl-template-fun 1- (a) "(~a - 1)" (v-matrix) 0 :pure t)

;; not really accurate as loses side effects of prototype
;; we use the compiler macro to patch this up
(v-def-glsl-template-fun float (x p) "float(~a)" (v-real v-float) 0 :pure t)
(v-def-glsl-template-fun float (x p) "double(~a)" (v-real v-double) 0 :pure t)

(v-define-compiler-macro float ((x v-real) (p v-float))
  (if (numberp p)
      `(float ,x)
      `(progn ,p (float ,x))))

(v-define-compiler-macro float ((x v-real) (p v-double))
  (if (numberp p)
      `(double ,x)
      `(progn ,p (double ,x))))


(macrolet ((define-type-pred (func-name &rest v-types)
             `(progn
                (v-def-glsl-template-fun ,func-name (x) "<invalid>" (v-type)
                                         v-bool :pure t)
                (v-define-compiler-macro ,func-name ((x v-type)
                                                     &environment env)
                  (let ((type (varjo:argument-type 'x env)))
                    (list 'progn
                          x
                          (or ,@(loop :for v-type :in v-types :collect
                                   `(v-typep type ',v-type)))))))))
  (define-type-pred arrayp v-array)
  (define-type-pred simple-vector-p v-array)
  (define-type-pred vectorp v-array)
  (define-type-pred functionp v-function-type)
  (define-type-pred complexp v-complex)
  (define-type-pred numberp v-number)
  (define-type-pred realp v-real)
  (define-type-pred floatp v-float v-double)
  (define-type-pred integerp v-integer)
  (define-type-pred rationalp v-rational))


(v-def-glsl-template-fun simple-bit-vector-p (a) "false" (v-type) v-bool)
(v-def-glsl-template-fun random-state-p (a) "false" (v-type) v-bool)



;; Could use v-integer for both of these when we add that
(v-def-glsl-template-fun integer-length (x) "32" (v-int) 0 :pure t)
(v-define-compiler-macro integer-length ((x v-int))
  (if (numberp x)
      32
      `(progn ,x 32)))

(v-def-glsl-template-fun integer-length (x) "32" (v-uint) 0 :pure t)
(v-define-compiler-macro integer-length ((x v-uint))
  (if (numberp x)
      32
      `(progn ,x 32)))


(v-def-glsl-template-fun signum (x) "sign(~a)" (v-real) 0 :pure t)
(v-def-glsl-template-fun evenp (x) "(~a % 2 == 0)" (v-int) v-bool :pure t)
(v-def-glsl-template-fun evenp (x) "(~a % 2 == 0)" (v-uint) v-bool :pure t)
(v-def-glsl-template-fun oddp (x) "(~a % 2 != 0)" (v-int) v-bool :pure t)
(v-def-glsl-template-fun oddp (x) "(~a % 2 != 0)" (v-uint) v-bool :pure t)

(v-def-glsl-template-fun minusp (x) "(~a < 0)" (v-real) v-bool :pure t)
(v-def-glsl-template-fun plusp (x) "(~a > 0)" (v-real) v-bool :pure t)

(v-defmacro dotimes ((var count &optional result) &body body)
  (assert (not result) () "Varjo: Currently we do not support the result form")
  (assert (symbolp var) () "Varjo: the var for dotimes was not a symbol")
  (let ((gcount (gensym "count")))
    `(let ((,gcount ,count))
       (for (,var 0) (< ,var ,gcount) (++ ,var)
            ,@body))))

(v-def-glsl-template-fun array-total-size (x) "~a.length()" (v-array)
                         v-int :pure t)

(v-define-compiler-macro array-total-size
    (&environment env &whole whole (x v-array))
  (let* ((type (varjo:argument-type 'x env))
         (len (first (v-dimensions type))))
    (if (numberp len)
        `(progn
           ,x
           ,len)
        whole)))

(v-def-glsl-template-fun isqrt (x) "floor(sqrt(~a))" (v-uint)
                         v-uint :pure t)


(v-def-glsl-template-fun logand (a b) "(~a & ~a)" (v-uint v-uint)
                         v-uint :pure t)
(v-def-glsl-template-fun logand (a b) "(~a & ~a)" (v-int v-int)
                         v-int :pure t)
(v-def-glsl-template-fun logand (a b c &rest c) "logand(~a, ~a, ~a, ~{, ~a~})"
                         (t t t &rest t) 0 :pure t)
(v-define-compiler-macro logand ((a t) (b t) (c t) &rest (d t))
  `(logand ,a (logand ,b (logand ,c ,@d))))
(v-def-glsl-template-fun logand (a) "-1" (v-integer) 0 :pure t)
(v-define-compiler-macro logand ((a v-integer))
  `(progn ,a -1))

(v-def-glsl-template-fun logxor (a b) "(~a ^ ~a)" (v-uint v-uint)
                         v-uint :pure t)
(v-def-glsl-template-fun logxor (a b) "(~a ^ ~a)" (v-int v-int)
                         v-int :pure t)
(v-def-glsl-template-fun logxor (a b c &rest c) "logxor(~a, ~a, ~a, ~{, ~a~})"
                         (t t t &rest t) 0 :pure t)
(v-define-compiler-macro logxor ((a t) (b t) (c t) &rest (d t))
  `(logand ,a (logand ,b (logand ,c ,@d))))
(v-def-glsl-template-fun logxor (a) "0" (v-integer) 0 :pure t)
(v-define-compiler-macro logxor ((a v-integer))
  `(progn ,a 0))

(v-def-glsl-template-fun logior (a b) "(~a | ~a)" (v-uint v-uint)
                         v-uint :pure t)
(v-def-glsl-template-fun logior (a b) "(~a | ~a)" (v-int v-int)
                         v-int :pure t)
(v-def-glsl-template-fun logior (a b c &rest c) "logior(~a, ~a, ~a, ~{, ~a~})"
                         (t t t &rest t) 0 :pure t)
(v-define-compiler-macro logior ((a t) (b t) (c t) &rest (d t))
  `(logand ,a (logand ,b (logand ,c ,@d))))
(v-def-glsl-template-fun logior (a) "0" (v-integer) 0 :pure t)
(v-define-compiler-macro logior ((a v-integer))
  `(progn ,a 0))

(v-def-glsl-template-fun logeql (a b) "~~(~a ^ ~a)" (v-uint v-uint)
                         v-uint :pure t)
(v-def-glsl-template-fun logeql (a b) "~~(~a ^ ~a)" (v-int v-int)
                         v-int :pure t)
(v-def-glsl-template-fun logeql (a b c &rest c) "logeql(~a, ~a, ~a, ~{, ~a~})"
                         (t t t &rest t) 0 :pure t)
(v-define-compiler-macro logeql ((a t) (b t) (c t) &rest (d t))
  `(lognot ,a (logxor ,b ,c ,@d)))
(v-def-glsl-template-fun logeql (a) "-1" (v-integer) 0 :pure t)
(v-define-compiler-macro logeql ((a v-integer))
  `(progn ,a -1))

(v-def-glsl-template-fun lognot (a) "(~~~a)" (v-integer) 0 :pure t)

(v-defun lognor ((a v-int) (b v-int)) (lognot (logor a b)))
(v-defun lognor ((a v-uint) (b v-uint)) (lognot (logor a b)))

(v-defun lognand ((a v-int) (b v-int)) (lognot (logand a b)))
(v-defun lognand ((a v-uint) (b v-uint)) (lognot (logand a b)))

(v-defun logorc1 ((a v-int) (b v-int)) (logor (lognot a) b))
(v-defun logorc1 ((a v-uint) (b v-uint)) (logor (lognot a) b))
(v-defun logorc2 ((a v-int) (b v-int)) (logor a (lognot b)))
(v-defun logorc2 ((a v-uint) (b v-uint)) (logor a (lognot b)))

(v-defun logandc1 ((a v-int) (b v-int)) (logand (lognot a) b))
(v-defun logandc1 ((a v-uint) (b v-uint)) (logand (lognot a) b))
(v-defun logandc2 ((a v-int) (b v-int)) (logand a (lognot b)))
(v-defun logandc2 ((a v-uint) (b v-uint)) (logand a (lognot b)))

(v-def-glsl-template-fun logcount (x) "bitCount(~a)" (v-integer) 0 :pure t)

(v-defun logtest ((a v-int) (b v-int))
  (not (zerop (logand x y))))

(v-defun logtest ((a v-uint) (b v-uint))
  (not (zerop (logand x y))))

;; natural log for 1 arg already defined in glsl
(v-def-glsl-template-fun log (x b) "(log2(~a) / log2(~a))" (v-float v-float) 0 :pure t)

;;------------------------------------------------------------
;; Limited Complement

(v-def-glsl-template-fun complement (x) "~a.length()" (v-function-type)
                         v-function-type :pure t)
(v-define-compiler-macro complement
    (&environment env (func v-function-type))
  (let ((type (varjo:argument-type 'func env)))
    (if (typep type 'v-any-one-of)
        (complement-v-any-one-of)
        (complement-single-func func type))))

(defun complement-single-func (func type)
  (let* ((arg-spec (v-argument-spec type))
         (ret-spec (v-return-spec type))
         (names (loop :for i :below (length arg-spec) :collect (gensym)))
         (primary-bool-p (v-typep (elt ret-spec 0) 'v-bool))
         (new-args (map 'list (lambda (n s) (list n (type->type-spec s)))
                        names arg-spec))
         (gfunc (gensym "func")))
    `(let ((,gfunc ,func))
       ,(if primary-bool-p
            `(lambda ,new-args
               (not (funcall ,gfunc ,@names)))
            `(lambda ,new-args
               (funcall ,gfunc ,@names)
               nil)))))

(defun complement-v-any-one-of ()
  (error "Varjo: Cannot yet make the complement in cases where there are many possible overloads.
Try qualifying the types in order to pass complement a specific overload."))

(v-defun scale-float ((f v-float)
                      (i v-int))
  (* f (expt 2f0 i)))

;;------------------------------------------------------------

;; ## Spec clash issues
;; floor (check api)
;; fceiling
;; ffloor
;; fround
;; ftruncate
;; rem
;; round
;; truncate
;; ceiling (check api)

;; ## Harder
;; rational
;; rationalize
;; decode-float
;; float-digits
;; float-precision
;; float-radix
;; float-sign
;; integer-decode-float
;; every      ;;-|
;; notany     ;; |
;; notevery   ;; |-- impl depends on if we go the sequence route
;; some       ;; |
;; constantly ;;-|
;; constantp
;; coerce
;; random
;; make-random-state (could be a seed for some rand func. however cl's random hard on gpu)
;; do
;; do*
;; setf expanders
;; rotatef
;; shiftf


;; ## Crazy Town
;; copy-seq
;; make-sequence
;; subseq
;; concatenate
;; elt
;; map
;; reduce
;; reverse
;; length
;; search
;; mismatch
;; find
;; find-if
;; find-if-not
;; count
;; count-if
;; count-if-not
;; position
;; position-if
;; position-if-not
;; remove
;; remove-duplicates
;; remove-if
;; remove-if-not
;; substitute
;; substitute-if
;; substitute-if-not
;; delete
;; delete-duplicates
;; delete-if
;; delete-if-not
;; nsubstitute
;; nsubstitute-if
;; nsubstitute-if-not
;; nreverse
;; replace
;; stable-sort
;; sort
;; map-into
;; merge
;; fill


;;------------------------------------------------------------

;; a 'do' form can be explained as
;;
;; (block nil
;;   (let ((var1 init1)
;;         (var2 init2)
;;         ...
;;         (varn initn))
;;     declarations
;;     (loop
;;        (when end-test (return (progn . result)))
;;        (tagbody . tagbody)
;;        (psetq var1 step1
;;               var2 step2
;;               ...
;;               varn stepn))))

#||
var result;
var a = init-a();
var b = init-b();
...
while(true)
{
    if (endtest-0())
    {
        result = calc-result-0();
        break;
    }
    if (endtest-1())
    {
        result = calc-result-1();
        break;
    }
    ...
    a = step-a();
    b = step-b();
    ...
}
||#

;;------------------------------------------------------------