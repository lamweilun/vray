module vray

import math
import math.vec
import rand

interface Material {
	scatter(r Ray, rec HitRecord, mut attenuation vec.Vec3[f32], mut scattered Ray) bool
}

pub struct Lambertian {
	albedo vec.Vec3[f32]
}

pub fn Lambertian.new(a vec.Vec3[f32]) Lambertian {
	return Lambertian{
		albedo: a
	}
}

pub fn (l Lambertian) scatter(r Ray, rec HitRecord, mut attenuation vec.Vec3[f32], mut scattered Ray) bool {
	mut scatter_direction := rec.normal + random_vec_in_unit_sphere()
	if scatter_direction.is_approx_zero(0.00001) {
		scatter_direction = rec.normal
	}

	scattered = Ray{
		origin: rec.point
		direction: scatter_direction
	}

	attenuation = l.albedo

	return true
}

pub struct Metal {
	albedo vec.Vec3[f32]
	fuzz   f32
}

pub fn Metal.new(a vec.Vec3[f32], f f32) Metal {
	return Metal{
		albedo: a
		fuzz: if f < 1 { f } else { 1 }
	}
}

pub fn (m Metal) scatter(r Ray, rec HitRecord, mut attenuation vec.Vec3[f32], mut scattered Ray) bool {
	reflected := reflect(r.direction.normalize(), rec.normal)
	scattered = Ray{
		origin: rec.point
		direction: reflected + random_vec_in_unit_sphere().mul_scalar(m.fuzz)
	}

	attenuation = m.albedo

	return true
}

pub struct Dielectric {
	// index of refraction
	ir f32
}

pub fn Dielectric.new(index f32) Dielectric {
	return Dielectric{
		ir: index
	}
}

pub fn Dielectric.reflectance(cosine f32, ref_idx f32) f32 {
	mut r0 := (1.0 - ref_idx) / (1 + ref_idx)
	r0 *= r0
	return r0 + (1.0 - r0) * math.powf(1.0 - cosine, 5.0)
}

pub fn (d Dielectric) scatter(r Ray, rec HitRecord, mut attenuation vec.Vec3[f32], mut scattered Ray) bool {
	attenuation = vec.vec3[f32](1, 1, 1)
	refraction_ratio := if rec.is_front { 1.0 / d.ir } else { d.ir }

	unit_direction := r.direction.normalize()
	cos_theta := f32(math.min(negate(unit_direction).dot(rec.normal), 1.0))
	sin_theta := f32(math.sqrtf(1.0 - cos_theta * cos_theta))

	cannot_refract := (refraction_ratio * sin_theta) > 1.0
	mut direction := vec.Vec3[f32]{}
	if cannot_refract || Dielectric.reflectance(cos_theta, refraction_ratio) > rand.f32() {
		direction = reflect(unit_direction, rec.normal)
	} else {
		direction = refract(unit_direction, rec.normal, refraction_ratio)
	}

	scattered = Ray{
		origin: rec.point
		direction: direction
	}

	return true
}
