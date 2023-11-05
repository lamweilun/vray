module vray

import math
import math.vec

pub struct Ray {
pub mut:
	origin    vec.Vec3[f32]
	direction vec.Vec3[f32]
}

pub fn (r Ray) at(t f32) vec.Vec3[f32] {
	return r.origin + (r.direction.mul_scalar(t))
}
