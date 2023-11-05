module main

import os
import math.vec
import ppm
import vray

fn main() {
	// Setup camera
	mut width := u32(512)
	mut height := u32(288)
	mut samples := u32(100)
	mut max_depth := u32(50)
	if os.args.len >= 3 {
		width = u32(os.args[1].int())
		height = u32(os.args[2].int())
		samples = u32(os.args[3].int())
		samples = u32(os.args[4].int())
	}
	cam := vray.Camera.new(width, height, samples, max_depth, vec.vec3[f32](0, 0, 1))

	// Setup world
	material_ground := vray.Lambertian.new(vec.vec3[f32](0.8, 0.8, 0.0))
	material_center := vray.Lambertian.new(vec.vec3[f32](0.7, 0.3, 0.3))
	material_left := vray.Metal.new(vec.vec3[f32](0.8, 0.8, 0.8), 0.3)
	material_right := vray.Metal.new(vec.vec3[f32](0.8, 0.6, 0.2), 0.1)

	mut world := vray.HittableList{}

	world.add(vray.Sphere{
		center: vec.vec3[f32](0.0, -101, -2.0)
		radius: 100.0
		mat: material_ground
	})

	world.add(vray.Sphere{
		center: vec.vec3[f32](0.0, 0.0, -2.0)
		radius: 1.0
		mat: material_center
	})

	world.add(vray.Sphere{
		center: vec.vec3[f32](-2.0, 0.0, -2.0)
		radius: 1.0
		mat: material_left
	})

	world.add(vray.Sphere{
		center: vec.vec3[f32](2.0, 0.0, -2.0)
		radius: 1.0
		mat: material_right
	})

	mut image := ppm.PPMImage.new(width, height)
	image.render(cam, world)
	image.output_to_file('output.ppm')
}
