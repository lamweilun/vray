module vray

import math

pub struct Interval {
pub mut:
	min f32 = f32(math.inf(1))
	max f32 = f32(math.inf(-1))
}

pub fn Interval.empty() Interval {
	return Interval{
		min: f32(math.inf(1))
		max: f32(math.inf(-1))
	}
}

pub fn Interval.universe() Interval {
	return Interval{
		min: f32(math.inf(-1))
		max: f32(math.inf(1))
	}
}

pub fn (i Interval) contains(x f32) bool {
	return i.min <= x && x <= i.max
}

pub fn (i Interval) surrounds(x f32) bool {
	return i.min < x && x < i.max
}

pub fn (i Interval) clamp(x f32) f32 {
	if x < i.min {
		return i.min
	}
	if x > i.max {
		return i.max
	}
	return x
}
