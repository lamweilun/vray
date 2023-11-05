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
	vfov              f32 = 90
	vup               vec.Vec3[f32] = vec.vec3[f32](0, 1, 0)
	lookat            vec.Vec3[f32] = vec.vec3[f32](0, 0, 0)
mut:
	pixel00_loc   vec.Vec3[f32]
	pixel_delta_u vec.Vec3[f32]
	pixel_delta_v vec.Vec3[f32]
	u             vec.Vec3[f32]
	v             vec.Vec3[f32]
	w             vec.Vec3[f32]
}

pub fn Camera.new(width u32, height u32, samples u32, depth u32, position vec.Vec3[f32], look_at vec.Vec3[f32]) Camera {
	mut cam := Camera{
		image_width: width
		image_height: height
		aspect_ratio: f32(width) / f32(height)
		center: position
		lookat: look_at
		samples_per_pixel: samples
		max_depth: depth
	}

	focal_length := (cam.center - cam.lookat).magnitude()
	theta := f32(math.radians(cam.vfov))
	h := math.tanf(theta * 0.5)
	vp_height := 2.0 * h * focal_length
	vp_width := vp_height * cam.aspect_ratio

	cam.w = (cam.center - cam.lookat).normalize()
	cam.u = (cam.vup.cross(cam.w))
	cam.v = cam.w.cross(cam.u)

	vp_u := cam.u.mul_scalar(vp_width)
	vp_v := negate(cam.v).mul_scalar(vp_height)

	cam.pixel_delta_u = vp_u.div_scalar(cam.image_width)
	cam.pixel_delta_v = vp_v.div_scalar(cam.image_height)

	vp_upper_left := cam.center - (cam.w.mul_scalar(focal_length)) - (vp_u.mul_scalar(0.5)) - (vp_v.mul_scalar(0.5))
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
