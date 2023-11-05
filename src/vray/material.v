module vray

import math.vec

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
	reflected := reflect[f32](r.direction.normalize(), rec.normal)
	scattered = Ray{
		origin: rec.point
		direction: reflected + random_vec_in_unit_sphere().mul_scalar(m.fuzz)
	}

	attenuation = m.albedo

	return true
}
