;; (in-package :varjo.tests)

(defmacro define-vari-trait (name (&rest type-vars) &body func-signatures)
  (declare (ignore name func-signatures type-vars)))

(define-vari-trait iter-state ())

(define-vari-trait iterable ((state iter-state))
  (length self)
  (make-sequence-like self)
  (make-sequence-like self :int)
  (limit self)
  (limit self :bool)
  (create-iterator-state self)
  (create-iterator-state self :bool)
  (next-iterator-state state)
  (next-iterator-state state :bool)
  (iterator-limit-check state state)
  (iterator-limit-check state state :bool)
  (element-for-state self state)
  (index-for-state state))

(defmacro define-implementation
    (impl-type-name (trait-name &rest type-vars &key &allow-other-keys)
     &body implementations &key &allow-other-keys)
  (declare (ignore impl-type-name trait-name type-vars implementations))
  nil)

(define-implementation range
    (iterable :state range-iter-state)
  :length (length range)
  :make-sequence-like (make-sequence-like range)
  :make-sequence-like (make-sequence-like range :int)
  :limit (limit range)
  :limit (limit range :bool)
  :create-iterator-state (create-iterator-state range)
  :create-iterator-state (create-iterator-state range :bool)
  :next-iterator-state (next-iterator-state range)
  :next-iterator-state (next-iterator-state range :bool)
  :iterator-limit-check (iterator-limit-check range)
  :iterator-limit-check (iterator-limit-check range :bool)
  :element-for-state (element-for-state range range-iter-state)
  :index-for-state (index-for-state range-iter-state))