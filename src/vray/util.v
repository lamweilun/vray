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

pub fn negate[T](v vec.Vec3[T]) vec.Vec3[T] {
	return vec.vec3[T](-v.x, -v.y, -v.z)
}

pub fn reflect[T](v vec.Vec3[T], n vec.Vec3[T]) vec.Vec3[T] {
	return v - (n.mul_scalar(v.dot(n) * 2.0))
}

pub fn refract[T](uv vec.Vec3[T], n vec.Vec3[T], etai_over_etat f32) vec.Vec3[T] {
	cos_theta := f32(math.min(negate[T](uv).dot(n), 1.0))
	r_out_perp := (uv + n.mul_scalar(cos_theta)).mul_scalar(etai_over_etat)
	r_out_parallel := n.mul_scalar(-math.sqrtf(math.abs(1.0 - r_out_perp.dot(r_out_perp))))
	return r_out_perp + r_out_parallel
}
