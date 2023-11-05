module vray

import math
import math.vec
import rand

pub struct Sphere {
pub mut:
	center vec.Vec3[f32]
	radius f32
}

pub fn Sphere.random_vec_in_unit_sphere() vec.Vec3[f32] {
	x := rand.f32_in_range(-1.0, 1.0) or { panic(err) }
	y := rand.f32_in_range(-1.0, 1.0) or { panic(err) }
	z := rand.f32_in_range(-1.0, 1.0) or { panic(err) }
	return vec.vec3[f32](x, y, z)
}

pub fn Sphere.random_vec_in_hemisphere(normal vec.Vec3[f32]) vec.Vec3[f32] {
	random_vec_in_sphere := Sphere.random_vec_in_unit_sphere()
	if random_vec_in_sphere.dot(normal) > 0.0 {
		return random_vec_in_sphere
	}
	return vec.vec3(-random_vec_in_sphere.x, -random_vec_in_sphere.y, -random_vec_in_sphere.z)
}

pub fn (s Sphere) hit(r Ray, ray_t Interval, mut rec HitRecord) bool {
	oc := r.origin - s.center
	a := r.direction.dot(r.direction)
	half_b := oc.dot(r.direction)
	c := oc.dot(oc) - (s.radius * s.radius)
	discriminant := (half_b * half_b) - (a * c)

	if discriminant < 0.0 {
		return false
	}

	if r.direction.is_approx_zero(0.00001) {
		return false
	}

	sqrtd := math.sqrtf(discriminant)
	mut root := (-half_b - sqrtd) / a
	if !ray_t.surrounds(root) {
		root = (-half_b + sqrtd) / a
		if !ray_t.surrounds(root) {
			return false
		}
	}

	rec.t = root
	rec.point = r.at(rec.t)

	outward_normal := (rec.point - s.center).div_scalar(s.radius)
	rec.set_face_normal(r, outward_normal.normalize())

	return true
}
