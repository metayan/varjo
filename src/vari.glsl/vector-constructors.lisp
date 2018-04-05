(in-package :vari.glsl)

;;------------------------------------------------------------

(v-def-glsl-template-fun vec3 (x y) "vec3(~a,~a)" (v-float v-vec2) v-vec3 :pure t)
(v-def-glsl-template-fun vec3 (x y) "vec3(~a,~a)" (v-vec2 v-float) v-vec3 :pure t)

(v-def-glsl-template-fun vec4 (x y) "vec4(~a,~a)" (v-vec2 v-vec2) v-vec4 :pure t)
(v-def-glsl-template-fun vec4 (x y) "vec4(~a,~a)" (v-float v-vec3) v-vec4 :pure t)
(v-def-glsl-template-fun vec4 (x y) "vec4(~a,~a)" (v-vec3 v-float) v-vec4 :pure t)

(v-def-glsl-template-fun vec4 (x y z) "vec4(~a,~a,~a)" (v-vec2 v-float v-float) v-vec4 :pure t)
(v-def-glsl-template-fun vec4 (x y z) "vec4(~a,~a,~a)" (v-float v-vec2 v-float) v-vec4 :pure t)
(v-def-glsl-template-fun vec4 (x y z) "vec4(~a,~a,~a)" (v-float v-float v-vec2) v-vec4 :pure t)

(v-def-glsl-template-fun vec2 (x y) "vec2(~a,~a)" (v-float v-float) v-vec2 :pure t)
(v-def-glsl-template-fun vec3 (x y z) "vec3(~a,~a,~a)" (v-float v-float v-float) v-vec3 :pure t)
(v-def-glsl-template-fun vec4 (x y z w) "vec4(~a,~a,~a,~a)" (v-float v-float v-float v-float)
                         v-vec4 :pure t)

(v-def-glsl-template-fun vec2 (x) "vec2(~a)" (v-float) v-vec2 :pure t)

(v-def-glsl-template-fun vec3 (x) "vec3(~a)" (v-float) v-vec3 :pure t)
(v-def-glsl-template-fun vec3 (x y) "vec3(~a, ~a, 0.0f)" (v-float v-float) v-vec3 :pure t)

(v-def-glsl-template-fun vec4 (x) "vec4(~a)" (v-float) v-vec4 :pure t)
(v-def-glsl-template-fun vec4 (x y) "vec4(~a, ~a, 0.0f, 0.0f)" (v-float v-float) v-vec4 :pure t)
(v-def-glsl-template-fun vec4 (x y z) "vec4(~a, ~a, ~a, 0.0f)" (v-float v-float v-float) v-vec4 :pure t)

;;------------------------------------------------------------

(v-def-glsl-template-fun bvec3 (x y) "bvec3(~a,~a)" (v-bool v-bvec2) v-bvec3 :pure t)
(v-def-glsl-template-fun bvec3 (x y) "bvec3(~a,~a)" (v-bvec2 v-bool) v-bvec3 :pure t)

(v-def-glsl-template-fun bvec4 (x y) "bvec4(~a,~a)" (v-bvec2 v-bvec2) v-bvec4 :pure t)
(v-def-glsl-template-fun bvec4 (x y) "bvec4(~a,~a)" (v-bool v-bvec3) v-bvec4 :pure t)
(v-def-glsl-template-fun bvec4 (x y) "bvec4(~a,~a)" (v-bvec3 v-bool) v-bvec4 :pure t)

(v-def-glsl-template-fun bvec4 (x y z) "bvec4(~a,~a,~a)" (v-bvec2 v-bool v-bool) v-bvec4 :pure t)
(v-def-glsl-template-fun bvec4 (x y z) "bvec4(~a,~a,~a)" (v-bool v-bvec2 v-bool) v-bvec4 :pure t)
(v-def-glsl-template-fun bvec4 (x y z) "bvec4(~a,~a,~a)" (v-bool v-bool v-bvec2) v-bvec4 :pure t)

(v-def-glsl-template-fun bvec2 (x y) "bvec2(~a,~a)" (v-bool v-bool) v-bvec2 :pure t)
(v-def-glsl-template-fun bvec3 (x y z) "bvec3(~a,~a,~a)" (v-bool v-bool v-bool) v-bvec3 :pure t)
(v-def-glsl-template-fun bvec4 (x y z w) "bvec4(~a,~a,~a,~a)" (v-bool v-bool v-bool v-bool)
         v-bvec4 :pure t)

;;------------------------------------------------------------

(v-def-glsl-template-fun ivec2 (x) "ivec2(~a)" (v-vec2) v-ivec2 :pure t)
(v-def-glsl-template-fun ivec3 (x) "ivec3(~a)" (v-vec3) v-ivec3 :pure t)
(v-def-glsl-template-fun ivec4 (x) "ivec4(~a)" (v-vec4) v-ivec4 :pure t)

(v-def-glsl-template-fun ivec3 (x y) "ivec3(~a,~a)" (v-int v-ivec2) v-ivec3 :pure t)
(v-def-glsl-template-fun ivec3 (x y) "ivec3(~a,~a)" (v-ivec2 v-int) v-ivec3 :pure t)

(v-def-glsl-template-fun ivec4 (x y) "ivec4(~a,~a)" (v-ivec2 v-ivec2) v-ivec4 :pure t)
(v-def-glsl-template-fun ivec4 (x y) "ivec4(~a,~a)" (v-int v-ivec3) v-ivec4 :pure t)
(v-def-glsl-template-fun ivec4 (x y) "ivec4(~a,~a)" (v-ivec3 v-int) v-ivec4 :pure t)

(v-def-glsl-template-fun ivec4 (x y z) "ivec4(~a,~a,~a)" (v-ivec2 v-int v-int) v-ivec4 :pure t)
(v-def-glsl-template-fun ivec4 (x y z) "ivec4(~a,~a,~a)" (v-int v-ivec2 v-int) v-ivec4 :pure t)
(v-def-glsl-template-fun ivec4 (x y z) "ivec4(~a,~a,~a)" (v-int v-int v-ivec2) v-ivec4 :pure t)

(v-def-glsl-template-fun ivec2 (x y) "ivec2(~a,~a)" (v-int v-int) v-ivec2 :pure t)
(v-def-glsl-template-fun ivec3 (x y z) "ivec3(~a,~a,~a)" (v-int v-int v-int) v-ivec3 :pure t)
(v-def-glsl-template-fun ivec4 (x y z w) "ivec4(~a,~a,~a,~a)" (v-int v-int v-int v-int)
         v-ivec4 :pure t)

(v-def-glsl-template-fun ivec2 (x) "ivec2(~a)" (v-int) v-ivec2 :pure t)

(v-def-glsl-template-fun ivec3 (x) "ivec3(~a)" (v-int) v-ivec3 :pure t)
(v-def-glsl-template-fun ivec3 (x y) "ivec3(~a, ~a, 0)" (v-int v-int) v-ivec3 :pure t)

(v-def-glsl-template-fun ivec4 (x) "ivec4(~a)" (v-int) v-ivec4 :pure t)
(v-def-glsl-template-fun ivec4 (x y) "ivec4(~a, ~a, 0, 0)" (v-int v-int) v-ivec4 :pure t)
(v-def-glsl-template-fun ivec4 (x y z) "ivec4(~a, ~a, ~a, 0)" (v-int v-int v-int) v-ivec4 :pure t)

;;------------------------------------------------------------

(v-def-glsl-template-fun uvec3 (x y) "uvec3(~a,~a)" (v-uint v-uvec2) v-uvec3 :pure t)
(v-def-glsl-template-fun uvec3 (x y) "uvec3(~a,~a)" (v-uvec2 v-uint) v-uvec3 :pure t)

(v-def-glsl-template-fun uvec4 (x y) "uvec4(~a,~a)" (v-uvec2 v-uvec2) v-uvec4 :pure t)
(v-def-glsl-template-fun uvec4 (x y) "uvec4(~a,~a)" (v-uint v-uvec3) v-uvec4 :pure t)
(v-def-glsl-template-fun uvec4 (x y) "uvec4(~a,~a)" (v-uvec3 v-uint) v-uvec4 :pure t)

(v-def-glsl-template-fun uvec4 (x y z) "uvec4(~a,~a,~a)" (v-uvec2 v-uint v-uint) v-uvec4 :pure t)
(v-def-glsl-template-fun uvec4 (x y z) "uvec4(~a,~a,~a)" (v-uint v-uvec2 v-uint) v-uvec4 :pure t)
(v-def-glsl-template-fun uvec4 (x y z) "uvec4(~a,~a,~a)" (v-uint v-uint v-uvec2) v-uvec4 :pure t)

(v-def-glsl-template-fun uvec2 (x y) "uvec2(~a,~a)" (v-uint v-uint) v-uvec2 :pure t)
(v-def-glsl-template-fun uvec3 (x y z) "uvec3(~a,~a,~a)" (v-uint v-uint v-uint) v-uvec3 :pure t)
(v-def-glsl-template-fun uvec4 (x y z w) "uvec4(~a,~a,~a,~a)" (v-uint v-uint v-uint v-uint)
         v-uvec4 :pure t)

(v-def-glsl-template-fun uvec2 (x) "uvec2(~a)" (v-uint) v-uvec2 :pure t)

(v-def-glsl-template-fun uvec3 (x) "uvec3(~a)" (v-uint) v-uvec3 :pure t)
(v-def-glsl-template-fun uvec3 (x y) "uvec3(~a, ~a, 0)" (v-uint v-uint) v-uvec3 :pure t)

(v-def-glsl-template-fun uvec4 (x) "uvec4(~a)" (v-uint) v-uvec4 :pure t)
(v-def-glsl-template-fun uvec4 (x y) "uvec4(~a, ~a, 0, 0)" (v-uint v-uint) v-uvec4 :pure t)
(v-def-glsl-template-fun uvec4 (x y z) "uvec4(~a, ~a, ~a, 0)" (v-uint v-uint v-uint) v-uvec4 :pure t)

;;------------------------------------------------------------

(v-def-glsl-template-fun dvec3 (x y) "dvec3(~a,~a)" (v-double v-dvec2) v-dvec3 :pure t)
(v-def-glsl-template-fun dvec3 (x y) "dvec3(~a,~a)" (v-dvec2 v-double) v-dvec3 :pure t)

(v-def-glsl-template-fun dvec4 (x y) "dvec4(~a,~a)" (v-dvec2 v-dvec2) v-dvec4 :pure t)
(v-def-glsl-template-fun dvec4 (x y) "dvec4(~a,~a)" (v-double v-dvec3) v-dvec4 :pure t)
(v-def-glsl-template-fun dvec4 (x y) "dvec4(~a,~a)" (v-dvec3 v-double) v-dvec4 :pure t)

(v-def-glsl-template-fun dvec4 (x y z) "dvec4(~a,~a,~a)" (v-dvec2 v-double v-double) v-dvec4 :pure t)
(v-def-glsl-template-fun dvec4 (x y z) "dvec4(~a,~a,~a)" (v-double v-dvec2 v-double) v-dvec4 :pure t)
(v-def-glsl-template-fun dvec4 (x y z) "dvec4(~a,~a,~a)" (v-double v-double v-dvec2) v-dvec4 :pure t)

(v-def-glsl-template-fun dvec2 (x y) "dvec2(~a,~a)" (v-double v-double) v-dvec2 :pure t)
(v-def-glsl-template-fun dvec3 (x y z) "dvec3(~a,~a,~a)" (v-double v-double v-double) v-dvec3 :pure t)
(v-def-glsl-template-fun dvec4 (x y z w) "dvec4(~a,~a,~a,~a)" (v-double v-double v-double v-double)
         v-dvec4 :pure t)

(v-def-glsl-template-fun dvec2 (x) "dvec2(~a)" (v-double) v-dvec2 :pure t)

(v-def-glsl-template-fun dvec3 (x) "dvec3(~a)" (v-double) v-dvec3 :pure t)
(v-def-glsl-template-fun dvec3 (x y) "dvec3(~a, ~a, 0.0lf)" (v-double v-double) v-dvec3 :pure t)

(v-def-glsl-template-fun dvec4 (x) "dvec4(~a)" (v-double) v-dvec4 :pure t)
(v-def-glsl-template-fun dvec4 (x y) "dvec4(~a, ~a, 0.0lf, 0.0lf)" (v-double v-double) v-dvec4 :pure t)
(v-def-glsl-template-fun dvec4 (x y z) "dvec4(~a, ~a, ~a, 0.0lf)" (v-double v-double v-double) v-dvec4 :pure t)

;;------------------------------------------------------------