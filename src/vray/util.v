module vray

import math
import math.vec
import rand

pub fn random_vec_in_unit_sphere() vec.Vec3[f32] {
	x := rand.f32_in_range(-1.0, 1.0) or { panic(err) }
	y := rand.f32_in_range(-1.0, 1.0) or { panic(err) }
	z := rand.f32_in_range(-1.0, 1.0) or { panic(err) }
	return vec.vec3[f32](x, y, z)
}

pub fn random_vec_in_hemisphere(normal vec.Vec3[f32]) vec.Vec3[f32] {
	random_vec_in_sphere := random_vec_in_unit_sphere()
	if random_vec_in_sphere.dot(normal) > 0.0 {
		return random_vec_in_sphere
	}
	return vec.vec3(-random_vec_in_sphere.x, -random_vec_in_sphere.y, -random_vec_in_sphere.z)
}

pub fn reflect[T](v vec.Vec3[T], n vec.Vec3[T]) vec.Vec3[T] {
	return v - (n.mul_scalar(v.dot(n) * 2.0))
}
