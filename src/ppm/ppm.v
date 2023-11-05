module ppm

import math.vec
import os
import strings
import vray
import math

pub struct PPMImage {
mut:
	width  u32
	height u32
	data   string
}

pub fn PPMImage.new(w u32, h u32) PPMImage {
	return PPMImage{
		width: w
		height: h
	}
}

pub fn (i PPMImage) get_width() u32 {
	return i.width
}

pub fn (i PPMImage) get_height() u32 {
	return i.height
}

pub fn (i PPMImage) get_data() string {
	return i.data
}

fn write_color(mut b strings.Builder, col vec.Vec3[f32], samples u32) {
	scale := 1.0 / f32(samples)
	mut out_color := col.mul_scalar(scale)
	out_color.x = math.sqrtf(out_color.x)
	out_color.y = math.sqrtf(out_color.y)
	out_color.z = math.sqrtf(out_color.z)
	i := vray.Interval{
		min: 0.0
		max: 1.0
	}
	b.write_decimal(u32(i.clamp(out_color.x) * 255.0))
	b.write_string(' ')
	b.write_decimal(u32(i.clamp(out_color.y) * 255.0))
	b.write_string(' ')
	b.write_decimal(u32(i.clamp(out_color.z) * 255.0))
	b.writeln('')
}

pub fn (mut i PPMImage) render(cam vray.Camera, world vray.HittableList) {
	mut builder := strings.new_builder(0)
	for y := u32(0); y < i.height; y++ {
		for x := u32(0); x < i.width; x++ {
			mut col := vec.vec3[f32](0, 0, 0)
			for s := u32(0); s < cam.samples_per_pixel; s++ {
				ray := cam.get_random_ray(x, y)
				col += vray.IHittable(world).ray_color(ray, cam.max_depth)
			}

			write_color(mut builder, col, cam.samples_per_pixel)
		}
	}
	i.data = builder.str()
}

pub fn (i PPMImage) output_to_file(file_path string) {
	mut builder := strings.new_builder(0)
	builder.writeln('P3')
	builder.write_decimal(i.width)
	builder.write_string(' ')
	builder.write_decimal(i.height)
	builder.writeln('')
	builder.write_decimal(255)
	builder.writeln('')
	builder.write_string(i.get_data())
	os.write_file(file_path, builder.str()) or { panic(err) }
}
