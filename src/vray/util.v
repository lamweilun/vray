module vray

import math
import math.vec
import rand

pub fn random_color_in_range(min f32, max f32) vec.Vec3[f32] {
	x := rand.f32_in_range(min, max) or { panic(err) }
	y := rand.f32_in_range(min, max) or { panic(err) }
	z := rand.f32_in_range(min, max) or { panic(err) }
	return vec.vec3(x, y, z)
}

pub fn random_color() vec.Vec3[f32] {
	return random_color_in_range(0.0, 1.0)
}

pub fn random_vec_in_unit_sphere() vec.Vec3[f32] {
	x := rand.f32_in_range(-1.0, 1.0) or { panic(err) }
	y := rand.f32_in_range(-1.0, 1.0) or { panic(err) }
	z := rand.f32_in_range(-1.0, 1.0) or { panic(err) }
	return vec.vec3[f32](x, y, z).normalize()
}

pub fn random_vec_in_hemisphere(normal vec.Vec3[f32]) vec.Vec3[f32] {
	random_vec_in_sphere := random_vec_in_unit_sphere()
	if random_vec_in_sphere.dot(normal) > 0.0 {
		return random_vec_in_sphere
	}
	return vec.vec3(-random_vec_in_sphere.x, -random_vec_in_sphere.y, -random_vec_in_sphere.z)
}

pub fn random_vec_in_unit_disk() vec.Vec3[f32] {
	mut random_vec := random_vec_in_unit_sphere()
	random_vec.z = 0
	random_vec = random_vec.normalize()
	return random_vec
}

pub fn negate[T](v vec.Vec3[T]) vec.Vec3[T] {
	return vec.vec3[T](-v.x, -v.y, -v.z)
}

pub fn reflect[T](v vec.Vec3[T], n vec.Vec3[T]) vec.Vec3[T] {
	return v - (n.mul_scalar(v.dot(n) * 2.0))
}

pub fn refract[T](v vec.Vec3[T], n vec.Vec3[T], ratio f32) vec.Vec3[T] {
	n_dot_i := n.dot(v)
	k := 1.0 - (ratio * ratio) * (1.0 - n_dot_i * n_dot_i)
	if k < 0.0 {
		return vec.vec3[f32](0, 0, 0)
	}
	return v.mul_scalar(ratio) - (n.mul_scalar(ratio * n_dot_i + math.sqrtf(k)))
}
