module vray

import math
import math.vec
import rand

pub struct Camera {
pub:
	image_width       u32
	image_height      u32
	center            vec.Vec3[f32]
	aspect_ratio      f32
	samples_per_pixel u32 = 100
	max_depth         u32 = 50
mut:
	pixel00_loc   vec.Vec3[f32]
	pixel_delta_u vec.Vec3[f32]
	pixel_delta_v vec.Vec3[f32]
}

pub fn Camera.new(width u32, height u32, samples u32, depth u32, position vec.Vec3[f32]) Camera {
	mut cam := Camera{
		image_width: width
		image_height: height
		aspect_ratio: f32(width) / f32(height)
		center: position
		samples_per_pixel: samples
		max_depth: depth
	}

	focal_length := f32(1.0)
	vp_height := f32(2.0)
	vp_width := vp_height * cam.aspect_ratio

	vp_u := vec.vec3[f32](vp_width, 0, 0)
	vp_v := vec.vec3[f32](0, -vp_height, 0)

	cam.pixel_delta_u = vp_u.div_scalar(cam.image_width)
	cam.pixel_delta_v = vp_v.div_scalar(cam.image_height)

	vp_upper_left := cam.center - vec.vec3[f32](0.0, 0.0, focal_length) - vp_u.mul_scalar(0.5) - vp_v.mul_scalar(0.5)
	cam.pixel00_loc = vp_upper_left + (cam.pixel_delta_u + cam.pixel_delta_v).mul_scalar(0.5)

	return cam
}

pub fn (cam Camera) get_pixel_position(x u32, y u32) vec.Vec3[f32] {
	return cam.pixel00_loc + cam.pixel_delta_u.mul_scalar(x) + cam.pixel_delta_v.mul_scalar(y)
}

pub fn (cam Camera) get_random_ray(x u32, y u32) Ray {
	return Ray{
		origin: cam.center
		direction: cam.get_pixel_position(x, y) + cam.get_random_pixel_position() - cam.center
	}
}

pub fn (cam Camera) get_random_pixel_position() vec.Vec3[f32] {
	// Returns a random point in the square surrounding a pixel at the origin.
	px := f32(-0.5) + rand.f32()
	py := f32(-0.5) + rand.f32()
	return (cam.pixel_delta_u.mul_scalar(px)) + (cam.pixel_delta_v.mul_scalar(py))
}
