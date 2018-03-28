(in-package :vari.cl)

(defun vari-describe (name &optional (stream *standard-output*))
  (let ((doc (or (gethash name glsl-docs:*variables*)
                 (gethash name glsl-docs:*functions*))))
    (when doc
      (format stream "~a~%~%~a" name doc))))

(defun vari-describe-string (name &optional (stream *standard-output*))
  (let* ((str (when (stringp name)
                (let ((p (position #\: name)))
                  (if p
                      (subseq name (1+ p))
                      name))))
         (name (if str
                   (cl:find-symbol (cl:string-upcase str) :glsl-symbols)
                   name))
         (var (gethash name glsl-docs:*variables*))
         (func (unless var (gethash name glsl-docs:*functions*))))
    (cond
      (var
       (format stream "~a~%~%~a" name var))
      (func
       (let* ((set
               (varjo.internals::find-global-form-binding-by-literal name t))
              (funcs
               (when set (functions set)))
              (args
               (loop
                  :for func :in funcs
                  :for spec := (v-argument-spec func)
                  :when (listp spec)
                  :collect
                  (handler-case
                      (loop :for type :in spec :collect
                         (type->type-spec type))
                    (error () nil))))
              (args (if (every #'identity args)
                        args
                        '(-)))
              (decl (search "Declaration" func))
              (param (search "Parameters" func))
              (doc (if (and decl param)
                       (concatenate
                        'string
                        (subseq func 0 decl)
                        (subseq func param))
                       func)))
         (format stream "~a~%~%~@[~{~a~%~}~%~]~a" name args doc))))))

(setf (gethash '* glsl-docs:*functions*)
      "Return the product of its arguments. With no args, returns 1.")

(setf (gethash '+ glsl-docs:*functions*)
      "Return the sum of its arguments. With no args, returns 0.")

(setf (gethash '- glsl-docs:*functions*)
      "Subtract the second and all subsequent arguments from the first;
  or with one argument, negate the first argument.")

(setf (gethash '/ glsl-docs:*functions*)
      "Divide the first argument by each of the following arguments, in turn.
  With one argument, return reciprocal.")

(setf (gethash '/= glsl-docs:*functions*)
      "Return T if no two of its arguments are numerically equal, NIL otherwise.")

(setf (gethash '1+ glsl-docs:*functions*)
      "Return NUMBER + 1.")

(setf (gethash '1- glsl-docs:*functions*)
      "Return NUMBER - 1.")

(setf (gethash '< glsl-docs:*functions*)
      "Return T if its arguments are in strictly increasing order, NIL otherwise.")

(setf (gethash '<= glsl-docs:*functions*)
      "Return T if arguments are in strictly non-decreasing order, NIL otherwise.")

(setf (gethash '= glsl-docs:*functions*)
      "Return T if all of its arguments are numerically equal, NIL otherwise.")

(setf (gethash '> glsl-docs:*functions*)
      "Return T if its arguments are in strictly decreasing order, NIL otherwise.")

(setf (gethash '>= glsl-docs:*functions*)
      "Return T if arguments are in strictly non-increasing order, NIL otherwise.")

(setf (gethash 'adjustable-array-p glsl-docs:*functions*)
      "Returns T is the array is adjustable, always returns NIL in Vari")

(setf (gethash 'aref glsl-docs:*functions*)
      "Return the element of the ARRAY specified by the SUBSCRIPT.")

(setf (gethash 'array-has-fill-pointer-p glsl-docs:*functions*)
      "Return T if the given ARRAY has a fill pointer, or NIL otherwise. Always returns NIL in Vari")

(setf (gethash 'array-rank glsl-docs:*functions*)
      "Return the number of dimensions of ARRAY. Always returns 1 for Vari arrays as GLSL doesnt support
multi-dimensional arrays.")

(setf (gethash 'array-total-size glsl-docs:*functions*)
      "Return the total number of elements in the Array.")

(setf (gethash 'arrayp glsl-docs:*functions*)
      "Return true if OBJECT is an ARRAY, and NIL otherwise.")

(setf (gethash 'break glsl-docs:*functions*)
      "break terminates the execution of the nearest enclosing for, switch, or while")

(setf (gethash 'case glsl-docs:*functions*)
      "CASE Keyform {(Key Form*)}*
Evaluates the Forms in the first clause with a Key EQL to the value of
Keyform. If a singleton key is T then the clause is a default clause.

Currently all Keys must be constantp")

(setf (gethash 'coerce glsl-docs:*functions*)
      "Coerce the Object to an object of type Output-Type-Spec.
Output-Type-Spec should not be quoted")

(setf (gethash 'compiled-function-p glsl-docs:*functions*)
      "Return true if OBJECT is a COMPILED-FUNCTION, and NIL otherwise.
All functions in Vari are compiled so this will return T for all functions")

(setf (gethash 'complement glsl-docs:*functions*)
      "Return a new function that returns T whenever FUNCTION returns NIL and
NIL whenever FUNCTION returns non-NIL.")

(setf (gethash 'complex glsl-docs:*functions*)
      "Return a complex number with the specified real and imaginary components.")

(setf (gethash 'complexp glsl-docs:*functions*)
      "Return true if OBJECT is a COMPLEX, and NIL otherwise.")

(setf (gethash 'conjugate glsl-docs:*functions*)
      "Return the complex conjugate of NUMBER. For non-complex numbers, this is
  an identity.")

(setf (gethash 'continue glsl-docs:*functions*)
      "The continue statement passes control to the next iteration of the for or
while statement in which it appears, bypassing any remaining statements.")

(setf (gethash 'DECF glsl-docs:*functions*)
      "The first argument is some location holding a number. This number is
  decremented by the second argument, DELTA, which defaults to 1.")

(setf (gethash 'DENOMINATOR glsl-docs:*functions*)
      "Return the denominator of NUMBER, which must be rational.")

(setf (gethash 'DO glsl-docs:*functions*)
      "DO ({(Var Init Step)}+) (Test Exit-Form+) Declaration* Form*
  Iteration construct. On subsequent iterations, the Vars are assigned the
  value of the Step form in parallel. The Test is evaluated before
  each evaluation of the body Forms. When the Test is true, the Exit-Forms
  are evaluated as a PROGN, with the result being the value of the DO.")

(setf (gethash 'EVENP glsl-docs:*functions*)
      "Is this integer even?")

(setf (gethash 'EXPT glsl-docs:*functions*)
      "Return BASE raised to the POWER.")

(setf (gethash 'FLET glsl-docs:*functions*)
      "FLET ({(name lambda-list declaration* form*)}*) declaration* body-form*

Evaluate the BODY-FORMS with local function definitions. The bindings do
not enclose the definitions; any use of NAME in the FORMS will refer to the
lexically apparent function definition in the enclosing environment.")

(setf (gethash 'FLOAT glsl-docs:*functions*)
      "Converts any REAL to a float. If OTHER is not provided, it returns a
  SINGLE-FLOAT if NUMBER is not already a FLOAT. If OTHER is provided, the
  result is the same float format as OTHER.")

(setf (gethash 'FLOAT-RADIX glsl-docs:*functions*)

      "Return (as an integer) the radix b of its floating-point argument.")

(setf (gethash 'FLOAT-SIGN glsl-docs:*functions*)
      "Return a floating-point number that has the same sign as
   FLOAT1 and, if FLOAT2 is given, has the same absolute value
   as FLOAT2.")

(setf (gethash 'FLOATP glsl-docs:*functions*)
      "Return true if OBJECT is a FLOAT, and NIL otherwise.")


(setf (gethash 'FUNCTION glsl-docs:*functions*)
      "FUNCTION name

Return the lexically apparent definition of the function NAME. If NAME is
a symbol the result will include all possible overloads of the function. To
specify a single function use the full signatures e.g. #'(sin :float)

NAME may also be a lambda expression.")

(setf (gethash 'FUNCTIONP glsl-docs:*functions*)
      "Return true if OBJECT is a FUNCTION, and NIL otherwise.")

(setf (gethash 'IDENTITY glsl-docs:*functions*)
      "This function simply returns what was passed to it.")

(setf (gethash 'IF glsl-docs:*functions*)
      "IF predicate then [else]

If PREDICATE evaluates to true, evaluate THEN and return its values,
otherwise evaluate ELSE and return its values. ELSE defaults to NIL.

If the branches evaluate to values of different type then the type
of the result will be (or type-from-then-branch type-from-else-branch)
This will cause issues if you attempt to return this value from a function
or pass it as an argument but is harmless in the non-tail position of a progn.

If `discard` is called in one branch then the result type of the IF is the
type of the branch that didnt discard")

(setf (gethash 'IMAGPART glsl-docs:*functions*)
      "Extract the imaginary part of a number.")

(setf (gethash 'INCF glsl-docs:*functions*)
      "The first argument is some location holding a number. This number is
  incremented by the second argument, DELTA, which defaults to 1.")

(setf (gethash 'INTEGER-LENGTH glsl-docs:*functions*)

      "Return the number of non-sign bits in the twos-complement representation
  of INTEGER.")

(setf (gethash 'INTEGERP glsl-docs:*functions*)
      "Return true if OBJECT is an INTEGER, and NIL otherwise.")

(setf (gethash 'ISQRT glsl-docs:*functions*)

      "Return the greatest integer less than or equal to the square root of N.")

(setf (gethash 'KEYWORDP glsl-docs:*functions*)

      "Return true if Object is a symbol in the \"KEYWORD\" package. Always NIL
in Vari")

(setf (gethash 'LABELS glsl-docs:*functions*)

      "LABELS ({(name lambda-list declaration* form*)}*) declaration* body-form*

Evaluate the BODY-FORMS with local function definitions. The bindings enclose
each subsequent definitions, so the defined functions can call the functions
defined before them in the definitions list.

Recursion (direct or indirect) is illegal in GLSL")

(setf (gethash 'LET glsl-docs:*functions*)

      "LET ({(var [value]) | var}*) declaration* form*

During evaluation of the FORMS, bind the VARS to the result of evaluating the
VALUE forms. The variables are bound in parallel after all of the VALUES forms
have been evaluated.")

(setf (gethash 'LET* glsl-docs:*functions*)

      "LET* ({(var [value]) | var}*) declaration* form*

Similar to LET, but the variables are bound sequentially, allowing each VALUE
form to reference any of the previous VARS.")

(setf (gethash 'LOCALLY glsl-docs:*functions*)

      "LOCALLY declaration* form*

Sequentially evaluate the FORMS in a lexical environment where the
DECLARATIONS have effect. If LOCALLY is a top level form, then the FORMS are
also processed as top level forms.")

(setf (gethash 'LOGAND glsl-docs:*functions*)
      "Return the bit-wise and of its arguments.")
(setf (gethash 'LOGCOUNT glsl-docs:*functions*)
      "Count the number of 1 bits if INTEGER is non-negative,
and the number of 0 bits if INTEGER is negative.")
(setf (gethash 'LOGIOR glsl-docs:*functions*)
      "Return the bit-wise or of its arguments")
(setf (gethash 'LOGNOT glsl-docs:*functions*)
      "Return the bit-wise logical not of the input")
(setf (gethash 'LOGXOR glsl-docs:*functions*)

      "Return the bit-wise exclusive or of its arguments.")
(setf (gethash 'MACROLET glsl-docs:*functions*)
      "MACROLET ({(name lambda-list form*)}*) body-form*

Evaluate the BODY-FORMS in an environment with the specified local macros
defined. NAME is the local macro name, LAMBDA-LIST is a DEFMACRO style
destructuring lambda list, and the FORMS evaluate to the expansion.")
(setf (gethash 'MINUSP glsl-docs:*functions*)
      "Is this real number strictly negative?")
(setf (gethash 'MULTIPLE-VALUE-CALL glsl-docs:*functions*)
      "MULTIPLE-VALUE-CALL function values-form*

Call FUNCTION, passing all the values of each VALUES-FORM as arguments,
values from the first VALUES-FORM making up the first argument, etc.")
(setf (gethash 'MULTIPLE-VALUE-PROG1 glsl-docs:*functions*)
      "MULTIPLE-VALUE-PROG1 values-form form*

Evaluate VALUES-FORM and then the FORMS, but return all the values of
VALUES-FORM.")
(setf (gethash 'NTH-VALUE glsl-docs:*functions*)
      "Evaluate FORM and return the Nth value (zero based)
 without consing a temporary list of values.")
(setf (gethash 'NUMBERP glsl-docs:*functions*)
      "Return true if OBJECT is a NUMBER, and NIL otherwise.")
(setf (gethash 'NUMERATOR glsl-docs:*functions*)
      "Return the numerator of NUMBER, which must be rational.")
(setf (gethash 'ODDP glsl-docs:*functions*)
      "Is this integer odd?")
(setf (gethash 'PLUSP glsl-docs:*functions*)
      "Is this real number strictly positive?")
(setf (gethash 'PROGN glsl-docs:*functions*)

      "PROGN form*

Evaluates each FORM in order, returning the values of the last form.

It is not legal to have an empty PROGN in Vari")
(setf (gethash 'RATIONALP glsl-docs:*functions*)
      "Return true if OBJECT is a RATIONAL, and NIL otherwise.")
(setf (gethash 'REALP glsl-docs:*functions*)
      "Return true if OBJECT is a REAL, and NIL otherwise.")
(setf (gethash 'REALPART glsl-docs:*functions*)
      "Extract the real part of a number.")
(setf (gethash 'ROW-MAJOR-AREF glsl-docs:*functions*)

      "Return the element of array corresponding to the row-major index. This is
   SETFable.")
(setf (gethash 'SETF glsl-docs:*functions*)
      "Takes pairs of arguments like SETQ. The first is a place and the second
  is the value that is supposed to go into that place. Returns the last
  value. The place argument may be any of the access forms for which SETF
  knows a corresponding setting form.")
(setf (gethash 'SIGNUM glsl-docs:*functions*)

      "If NUMBER is zero, return NUMBER, else return (/ NUMBER (ABS NUMBER)).")
(setf (gethash 'SIMPLE-BIT-VECTOR-P glsl-docs:*functions*)

      "Return true if OBJECT is a SIMPLE-BIT-VECTOR, and NIL otherwise.
Always NIL in Vari")
(setf (gethash 'SIMPLE-VECTOR-P glsl-docs:*functions*)

      "Return true if OBJECT is a SIMPLE-VECTOR, and NIL otherwise.
All arrays are simple-vectors in Vari")
(setf (gethash 'SVREF glsl-docs:*functions*)
      "Return the INDEXth element of the given Simple-Vector.")
(setf (gethash 'SYMBOL-MACROLET glsl-docs:*functions*)
      "SYMBOL-MACROLET ({(name expansion)}*) decl* form*

Define the NAMES as symbol macros with the given EXPANSIONS. Within the
body, references to a NAME will effectively be replaced with the EXPANSION."
      )
(setf (gethash 'SYMBOLP glsl-docs:*functions*)
      "Return true if OBJECT is a SYMBOL, and NIL otherwise.
Always NIL in Vari")

(setf (gethash 'THE glsl-docs:*functions*)
      "Specifies that the values returned by FORM conform to the VALUE-TYPE.

This becomes a compile-time assertion of the type, except in cases of global
variable capture where it can be used to inform the compiler of the type.")

(setf (gethash 'TYPECASE glsl-docs:*functions*)
      "TYPECASE Keyform {(Type Form*)}*
  Evaluates the Forms in the first clause for which TYPEP of Keyform and Type
  is true.")
(setf (gethash 'UNLESS glsl-docs:*functions*)
      "If the first argument is not true, the rest of the forms are
evaluated as a PROGN.")

(setf (gethash 'VALUES glsl-docs:*functions*)
      "Return all arguments, in order, as values.

You may also qualify the values. If the value is a list where the first symbol
is a qualifier-form then the last form is the value and the butlast forms are
treated as qualifiers.

For example:

    (values (v! 1 2 3 4)  ←[0]
            (:flat 10) ←[1]
            ((:feedback 1) (+ position (v! pos 0 0))) ←[2]
            ((:feedback 0) (v! 0.1 0 1)))             ←[2]

- [0] unqualified value
- [1] the value 10 is qualified as flat
- [2] two forms are qualfied as being the transform feedback of the stage
")
(setf (gethash 'VECTOR glsl-docs:*functions*)
      "Construct a SIMPLE-VECTOR from the given objects.")
(setf (gethash 'VECTORP glsl-docs:*functions*)
      "Return true if OBJECT is a VECTOR, and NIL otherwise.")
(setf (gethash 'WHEN glsl-docs:*functions*)
      "If the first argument is true, the rest of the forms are
evaluated as a PROGN.")
(setf (gethash 'ZEROP glsl-docs:*functions*)
      "Is this number zero?")
(setf (gethash 'AND glsl-docs:*functions*)
 "The macro and evaluates each form one at a time from left to right.
As soon as any form evaluates to nil, and returns nil without evaluating the
remaining forms. If all forms but the last evaluate to true values, and returns
the results produced by evaluating the last form. ")

(setf (gethash 'ARRAY-ROW-MAJOR-INDEX glsl-docs:*functions*)

 "Computes the position according to the row-major ordering of array for the
element that is specified by subscripts, and returns the offset of the element
in the computed position from the beginning of array.

For a one-dimensional array, the result of array-row-major-index equals
subscript.")

(setf (gethash 'COND glsl-docs:*functions*)

  "Syntax:

cond {clause}+ => result*

clause::= (test-form form+)

Arguments and Values:

test-form---a form.

forms---an implicit progn.

results---the values of the forms in the first clause whose test-form yields
          true, or the primary value of the test-form if there are no forms in
          that clause, or else void if no test-form yields true.

Description:

cond allows the execution of forms to be dependent on test-form.

Test-forms are evaluated one at a time in the order in which they are given in
the argument list until a test-form is found that evaluates to true.

If there are no forms in that clause, the primary value of the test-form is
returned by the cond form. Otherwise, the forms associated with this test-form
are evaluated in order, left to right, as an implicit progn, and the values
returned by the last form are returned by the cond form.

Once one test-form has yielded true, no additional test-forms are evaluated.
If no test-form yields true, the COND evaluates to void.")

(setf (gethash 'DOTIMES glsl-docs:*functions*)

    "Syntax:

dotimes (var count-form) declaration* {statement}+

=> void

Arguments and Values:

var---a symbol.

count-form---a form.

declaration---a declare expression; not evaluated.

statement---a compound form;

Description:

dotimes iterates over a series of integers.")

(setf (gethash 'EQL glsl-docs:*functions*)

 "Returns T is both arguments are numbers with the same value

GLSL does not provide a equivalent of EQ.")

(setf (gethash 'EQUAL glsl-docs:*functions*)

 "Returns T is both arguments are numbers with the same value, or in the case
of aggregates, if the are component-wise EQUAL.

EQUAL does not work on GLSL's opaque types")

(setf (gethash 'FLOAT-DIGITS glsl-docs:*functions*)

 "Returns the number of radix b digits used in the representation of float (including
any implicit digits, such as a ``hidden bit''). ")

(setf (gethash 'LAMBDA glsl-docs:*functions*)

    "lambda lambda-list [[declaration* | documentation]] form+ => function

Arguments and Values:

lambda-list---an ordinary lambda list.

declaration---a declare expression; not evaluated.

documentation---a string; not evaluated.

form---a form.

function---a function.

Description:

Provides a shorthand notation for a function special form involving a lambda expression such that:

    (lambda lambda-list [[declaration* | documentation]] form*)
 ==  (function (lambda lambda-list [[declaration* | documentation]] form*))
 ==  #'(lambda lambda-list [[declaration* | documentation]] form*)
")

(setf (gethash 'MAKE-ARRAY glsl-docs:*functions*)

 "WARNING: API of MAKE-ARRAY subject to change.

Description:

Creates and returns an array.

Dimensions represents the dimensionality of the new array. The array must
be single-dimensional and dimensions must be a number.

element-type indicates the type of the elements intended to be stored in the
new-array

If initial-element is supplied, it is used to initialize each element of
new-array. If initial-element is supplied, it must be of the type given by
element-type. initial-element must be constantp

initial-contents is used to initialize the contents of array. It must currently
be a quoted list, this is an issue and will be changed.")

(setf (gethash 'MULTIPLE-VALUE-BIND glsl-docs:*functions*)

      "Creates new variable bindings for the vars and executes a series of forms that use
these bindings.

The variable bindings created are lexical.

Values-form is evaluated, and each of the vars is bound to the respective value
returned by that form. The number of values returns by values-form must match
the number of forms in 'vars'. The vars are bound to the values over the
execution of the forms, which make up an implicit progn.

The scopes of the name binding and declarations do not include the values-form.")

(setf (gethash 'MULTIPLE-VALUE-SETQ glsl-docs:*functions*)

    "multiple-value-setq assigns values to vars.

The form is evaluated, and each var is assigned to the corresponding value
returned by that form. The number of values returns by values-form must match
the number of forms in 'vars'

If any var is the name of a symbol macro, then it is assigned as if by setf.")

(setf (gethash 'OR glsl-docs:*functions*)

 "or evaluates each form, one at a time, from left to right. The evaluation of
all forms terminates when a form evaluates to true (i.e., something other than
nil).")

(setf (gethash 'PROG1 glsl-docs:*functions*)

    "prog1 evaluates first-form and then forms, yielding as its only value the primary
value yielded by first-form." )

(setf (gethash 'PROG2 glsl-docs:*functions*)

    "prog2 evaluates first-form, then second-form, and then forms, yielding as
its only value the primary value yielded by second-form.")

(setf (gethash 'RANDOM-STATE-P glsl-docs:*functions*)

 "Returns true if object is of type random-state; otherwise, returns false.")

(setf (gethash 'RETURN glsl-docs:*functions*)
  "return terminates the execution of a function and returns control and values to the calling
function. The types from all return forms in a stage must be idential.")

(setf (gethash 'SETQ glsl-docs:*functions*)
 "Assigns a value to a variable.

    (setq var1 form1)

is the simple variable assignment statement of Lisp.
First form is evaluated and then the result is stored in the variable var1.

If any var refers to a binding made by symbol-macrolet, then that var is
reated as if setf (not setq) had been used.")

(setf (gethash 'SLOT-VALUE glsl-docs:*functions*)
 "The function slot-value returns the value of the slot named slot-name in the struct.

`setf` can be used with slot-value to change the value of a slot.")

(setf (gethash 'WITH-ACCESSORS glsl-docs:*functions*)
      "Creates a lexical environment in which the slots specified by slot-entry are
lexically available through their accessors as if they were variables.

The macro with-accessors invokes the appropriate accessors to access the slots
specified by slot-entry. Both setf and setq can be used to set the value of the slot.")

(setf (gethash 'WITH-SLOTS glsl-docs:*functions*)
      "The macro with-slots establishes a lexical environment for referring to the slots in
the struct named by the given slot-names as though they were variables.

Within such a context the value of the slot can be specified by using its
slot name, as if it were a lexically bound variable.

Both setf and setq can be used to set the value of the slot.

The macro with-slots translates an appearance of the slot name as a variable
into a call to slot-value. ")
