;;;; package.lisp

(defpackage #:varjo
  (:use #:cl :split-sequence #:alexandria #:cl-ppcre #:named-readtables)
  (:export :v-glsl-size
           :v-casts-to-p
           :v-casts-to
           :find-mutual-cast-type

           ;;type functions
           :v-spec-typep
           :type-specp
           :type->type-spec
           :type-spec->type
           :v-glsl-size
           :v-type-eq
           :v-typep
           :v-casts-to-p
           :v-casts-to
           :find-mutual-cast-type
           :v-special-functionp
           :v-errorp

           ;;type accessors
           :core-typep
           :v-argument-spec
           :v-dimensions
           :v-element-type
           :v-fake-type
           :v-glsl-name
           :v-glsl-spec-matchingp
           :v-glsl-string
           :v-payload
           :v-restriction
           :v-return-spec
           :v-signature
           :v-slots
           :v-true-type

           ;;types
           :add-type-shadow
           :un-shadow
           :v-t-type
           :v-type
           :v-stemcell
           :v-spec-type
           :v-tfd
           :v-tf
           :v-td
           :v-tb
           :v-tiu
           :v-i-ui
           :v-ti
           :v-tu
           :v-tvec
           :v-array
           :v-none
           :v-function
           :v-struct
           :v-user-struct
           :v-error
           :v-void
           :v-bool
           :v-number
           :v-int
           :v-uint
           :v-float
           :v-short-float
           :v-double
           :v-container
           :v-matrix
           :v-mat2
           :v-mat3
           :v-mat4
           :V-MAT2X2
           :V-MAT2X3
           :V-MAT2X4
           :V-MAT3X2
           :V-MAT3X3
           :V-MAT3X4
           :V-MAT4X2
           :V-MAT4X3
           :V-MAT4X4
           :v-vector
           :v-fvector
           :v-vec2
           :v-vec3
           :v-vec4
           :v-bvector
           :v-bvec2
           :v-bvec3
           :v-bvec4
           :v-uvector
           :v-uvec2
           :v-uvec3
           :v-uvec4
           :v-ivector
           :v-ivec2
           :v-ivec3
           :v-ivec4
           :v-dvector
           :v-dvec2
           :v-dvec3
           :v-dvec4
           :v-sampler
           :V-ISAMPLER-1D
           :V-ISAMPLER-1D-ARRAY
           :V-ISAMPLER-2D
           :V-ISAMPLER-2D-ARRAY
           :V-ISAMPLER-2D-MS
           :V-ISAMPLER-2D-MS-ARRAY
           :V-ISAMPLER-2D-RECT
           :V-ISAMPLER-3D
           :V-ISAMPLER-BUFFER
           :V-ISAMPLER-CUBE
           :V-ISAMPLER-CUBE-ARRAY
           :v-sampler-1D
           :v-sampler-1D-ARRAY
           :v-sampler-1D-ARRAY-SHADOW
           :v-sampler-1D-SHADOW
           :v-sampler-2D
           :v-sampler-2D-ARRAY
           :v-sampler-2D-ARRAY-SHADOW
           :v-sampler-2D-MS
           :v-sampler-2D-MS-ARRAY
           :v-sampler-2D-RECT
           :v-sampler-2D-RECT-SHADOW
           :v-sampler-2D-SHADOW
           :v-sampler-3D
           :v-sampler-BUFFER
           :v-sampler-CUBE
           :v-sampler-CUBE-ARRAY
           :v-sampler-CUBE-ARRAY-SHADOW
           :v-sampler-CUBE-SHADOW
           :V-USAMPLER-1D
           :V-USAMPLER-1D-ARRAY
           :V-USAMPLER-2D
           :V-USAMPLER-2D-ARRAY
           :V-USAMPLER-2D-MS
           :V-USAMPLER-2D-MS-ARRAY
           :V-USAMPLER-2D-RECT
           :V-USAMPLER-3D
           :V-USAMPLER-BUFFER
           :V-USAMPLER-CUBE
           :V-USAMPLER-CUBE-ARRAY

           ;;functions
           :TEXTURE-SIZE
           :TEXTURE
           :TEXTURE-PROJ
           :TEXTURE-LOD
           :TEXTURE-OFFSET
           :TEXEL-FETCH
           :TEXEL-FETCH-OFFSET
           :TEXTURE-PROJ-OFFSET
           :TEXTURE-LOD-OFFSET
           :TEXTURE-PROJ-LOD
           :TEXTURE-PROJ-LOD-OFFSET
           :TEXTURE-GRAD
           :TEXTURE-GRAD-OFFSET
           :TEXTURE-PROJ-GRAD
           :TEXTURE-PROJ-GRAD-OFFSET
           :X
           :Y
           :Z
           :W
           :%<
           :%>
           :%<=
           :%>=
           :%EQUAL
           :%EQL
           :%=
           :--
           :%+
           :%-
           :%*
           :%/
           ;; :CLAMP
           :BITFIELD-INSERT
           :MIX
           :FACEFORWARD
           :FMA
           :REFLECT
           :REFRACT
           :SMOOTHSTEP
           :POW
           :ISINF
           :ISNAN
           :V-NOT
           :V-EQUAL
           :V-NOT-EQUAL
           :GREATER-THAN
           :GREATER-THAN-EQUAL
           :LESS-THAN
           :LESS-THAN-EQUAL
           :NOT-EQUAL
           :ALL
           :ANY
           :ATOMIC-COUNTER
           :ATOMIC-COUNTER-DECREMENT
           :ATOMIC-COUNTER-INCREMENT
           :BARRIER
           :BITFIELD-EXTRACT
           :BITFIELD-REVERSE
           :CEIL
           :CROSS
           :D-FDX
           :D-FDY
           :DEGREES
           :DETERMINANT
           :DISTANCE
           :DOT
           :EMIT-STREAM-VERTEX
           :EMIT-VERTEX
           :END-PRIMITIVE
           :END-STREAM-PRIMITIVE
           :EXP-2
           :FRACT
           :FWIDTH
           :GROUP-MEMORY-BARRIER
           :IMAGE-SIZE
           :INTERPOLATE-AT-CENTROID
           :INTERPOLATE-AT-OFFSET
           :INTERPOLATE-AT-SAMPLE
           :INVERSE
           :INVERSESQRT
           :LOG-2
           :MATRIX-COMP-MULT
           :MEMORY-BARRIER
           :MEMORY-BARRIER-ATOMIC-COUNTER
           :MEMORY-BARRIER-BUFFER
           :MEMORY-BARRIER-IMAGE
           :MEMORY-BARRIER-SHARED
           :NOISE-1
           :NORMALIZE
           :OUTER-PRODUCT
           :PACK-DOUBLE-2X-3-2
           :PACK-HALF-2X-1-6
           :PACK-SNORM-2X-1-6
           :PACK-SNORM-4X-8
           :PACK-UNORM-2X-1-6
           :PACK-UNORM-4X-8
           :RADIANS
           :ROUND-EVEN
           :SIGN
           :TRUNC
           :UNPACK-DOUBLE-2X-3-2
           :UNPACK-HALF-2X-1-6
           :UNPACK-SNORM-2X-1-6
           :UNPACK-SNORM-4X-8
           :UNPACK-UNORM-2X-1-6
           :UNPACK-UNORM-4X-8
           :TRANSPOSE
           :IMAGE-ATOMIC-ADD
           :IMAGE-ATOMIC-AND
           :IMAGE-ATOMIC-COMP-SWAP
           :IMAGE-ATOMIC-EXCHANGE
           :IMAGE-ATOMIC-MAX
           :IMAGE-ATOMIC-MIN
           :IMAGE-ATOMIC-OR
           :IMAGE-ATOMIC-XOR
           :IMAGE-LOAD
           :IMAGE-STORE

           ;;definitions
           :v-defstruct
           :v-defun
           :v-defmacro
           :v-define-compiler-macro

	   ;;flow-ids
	   :flow-id!
	   :id=
	   :id~=

           ;;compiler
           :varjo->glsl
           :with-stemcell-infer-hook

           ;;front-end
           :translate
           :rolling-translate
           :split-arguments
           :v-macroexpand-all
           :v-compiler-macroexpand-all
           :*stage-types*

           ;;compile-result
	   :glsl-code
	   :stage-type
	   :out-vars
	   :in-args
	   :uniforms
	   :implicit-uniforms
	   :context
	   :function-calls
	   :used-macros
	   :used-compiler-macros
	   :used-symbol-macros

           ;;utils
           :lambda-list-split
           :pipe->))
