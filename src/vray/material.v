module vray

import math.vec
import math

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

pub fn (d Dielectric) scatter(r Ray, rec HitRecord, mut attenuation vec.Vec3[f32], mut scattered Ray) bool {
	attenuation = vec.vec3[f32](1.0, 1.0, 1.0)
	refraction_ratio := if rec.is_front { 1.0 / d.ir } else { d.ir }

	unit_direction := r.direction.normalize()
	cos_theta := f32(math.min(negate(unit_direction).dot(rec.normal), 1.0))
	sin_theta := f32(math.sqrtf(1.0 - cos_theta * cos_theta))

	mut direction := vec.vec3[f32](0, 0, 0)
	cannot_refract := refraction_ratio * sin_theta > 1.0
	if cannot_refract {
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
