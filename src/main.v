module main

import os
import math.vec
import ppm
import rand
import vray

fn main() {
	// Setup camera
	mut width := u32(512)
	mut height := u32(288)
	mut samples := u32(500)
	mut max_depth := u32(50)
	if os.args.len >= 3 {
		width = u32(os.args[1].int())
		height = u32(os.args[2].int())
		samples = u32(os.args[3].int())
		max_depth = u32(os.args[4].int())
	}
	cam_pos := vec.vec3[f32](10, 6, 10)
	cam_lookat := vec.vec3[f32](0, 0, 0)
	cam := vray.Camera.new(width, height, samples, max_depth, cam_pos, cam_lookat)

	// Setup world
	mut world := vray.HittableList{}
	world.add(vray.Sphere.new(vec.vec3[f32](0.0, -200, 0), 200.0, vray.Lambertian.new(vec.vec3[f32](0.5,
		0.5, 0.5))))

	for i := -3; i < 3; i++ {
		for j := -3; j < 3; j++ {
			choose_mat := rand.f32()
			center_pos := vec.vec3[f32](i + 0.9 * rand.f32(), 0.2, j + 0.9 * rand.f32())
			if (center_pos - vec.vec3[f32](4, 0.2, 0)).magnitude() > 0.9 {
				if choose_mat < 0.8 {
					// diffuse
					world.add(vray.Sphere.new(center_pos, 0.2, vray.Lambertian.new(vray.random_color() * vray.random_color())))
				} else if choose_mat < 0.95 {
					// metal
					fuzz := rand.f32_in_range(0, 0.5) or { panic(err) }
					world.add(vray.Sphere.new(center_pos, 0.2, vray.Metal.new(vray.random_color_in_range(0.5,
						1), fuzz)))
				} else {
					// glass
					world.add(vray.Sphere.new(center_pos, 0.2, vray.Dielectric.new(rand.f32_in_range(1.5,
						2.4) or { panic(err) })))
				}
			}
		}
	}
	world.add(vray.Sphere.new(vec.vec3[f32](0, 1, 0), 1.0, vray.Dielectric.new(1.5)))
	world.add(vray.Sphere.new(vec.vec3[f32](-4, 1, 0), 1.0, vray.Lambertian.new(vec.vec3[f32](0.4,
		0.2, 0.1))))
	world.add(vray.Sphere.new(vec.vec3[f32](4, 1, 0), 1.0, vray.Metal.new(vray.random_color_in_range(0.5,
		1), rand.f32_in_range(0, 0.5) or { panic(err) })))

	// Render image
	mut image := ppm.PPMImage.new(width, height)
	image.render(cam, world)
	image.output_to_file('output.ppm')
}
