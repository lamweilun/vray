module vray

import math
import math.vec

pub struct Sphere {
pub mut:
	center vec.Vec3[f32]
	radius f32
pub:
	mat Material
}

pub fn Sphere.new(c vec.Vec3[f32], r f32, m Material) Sphere {
	return Sphere{
		center: c
		radius: r
		mat: m
	}
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
	rec.mat = s.mat

	return true
}
