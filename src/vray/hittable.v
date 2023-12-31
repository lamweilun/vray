module vray

import math.vec
import math

pub struct HitRecord {
pub mut:
	point    vec.Vec3[f32]
	normal   vec.Vec3[f32]
	mat      Material
	t        f32
	is_front bool
}

pub fn (mut record HitRecord) set_face_normal(ray Ray, outward_normal vec.Vec3[f32]) {
	// outward normal is assumed to be normalized
	record.is_front = ray.direction.dot(outward_normal) < 0
	if record.is_front {
		record.normal = outward_normal
	} else {
		record.normal = negate(outward_normal)
	}
}

interface IHittable {
	hit(r Ray, ray_t Interval, mut rec HitRecord) bool
}

pub fn (hittable IHittable) ray_color(r Ray, depth u32) vec.Vec3[f32] {
	if depth == 0 {
		return vec.vec3[f32](0, 0, 0)
	}

	mut rec := HitRecord{}
	if hittable.hit(r, Interval{0.00001, f32(math.inf(1))}, mut rec) {
		mut scattered := Ray{}
		mut attenuation := vec.vec3[f32](0.0, 0.0, 0.0)
		if rec.mat.scatter(r, rec, mut attenuation, mut scattered) {
			return attenuation * hittable.ray_color(scattered, depth - 1)
		}
		return vec.vec3[f32](0, 0, 0)
	}

	unit_dir := r.direction.normalize()
	a := (unit_dir.y + 1.0) * 0.5
	return vec.vec3[f32](0.5, 0.7, 1.0).mul_scalar(a) + vec.vec3[f32](1, 1, 1).mul_scalar(1.0 - a)
}

pub struct HittableList {
pub mut:
	objects []IHittable
}

pub fn (mut hl HittableList) add(obj IHittable) {
	hl.objects << obj
}

pub fn (mut hl HittableList) clear() {
	hl.objects.clear()
}

pub fn (hl HittableList) hit(r Ray, ray_t Interval, mut rec HitRecord) bool {
	mut temp_rec := HitRecord{}
	mut hit := false
	mut closest_t := ray_t.max
	for obj in hl.objects {
		if obj.hit(r, Interval{ray_t.min, closest_t}, mut temp_rec) {
			hit = true
			closest_t = temp_rec.t
			rec = temp_rec
		}
	}
	return hit
}
