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
	cam := vray.Camera.new(width, height, samples, max_depth, vec.vec3[f32](0, 0, 0))

	// Setup world
	mut world := vray.HittableList{}
	world.add(vray.Sphere{ center: vec.Vec3[f32]{0.0, 0.0, -2.0}, radius: 1.0 })
	world.add(vray.Sphere{ center: vec.Vec3[f32]{0.0, -101, -2.0}, radius: 100.0 })

	mut image := ppm.PPMImage.new(width, height)
	image.render(cam, world)
	image.output_to_file('output.ppm')
}
