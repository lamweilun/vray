# vray

## Description
vray is a simple ray tracer program, written only in [vlang](https://vlang.io/), based entirely off of [Ray Tracing in One Weekend](https://raytracing.github.io/books/RayTracingInOneWeekend.html) by [Peter Shirley](https://github.com/petershirley), [Trevor David Black](https://github.com/trevordblack) and [Steve Hollasch](https://github.com/hollasch).

This program is an exercise (more like an excuse really) for me to learn vlang the hardway, and what better way than to reimplement an existing project written in another language (C++ in this case).

## What is vlang?
Check out [vlang here](https://vlang.io/) (GitHub [here](https://github.com/vlang/v)). It's a general purpose programming language that is heavily inspired by C and Go.

## Tested on
- This has been tested to compile and ran on Windows, using the following vlang version
  - V 0.4.2 140c838, timestamp: 2023-11-06 12:24:58 +0200
- Untested on Linux/macOS, but it should work~

## Progress
- Pretty much completed everything from [Ray Tracing in One Weekend](https://raytracing.github.io/books/RayTracingInOneWeekend.html)
- In the midst of planning/adding my own features...

## Sample Output
![](output.png)
---
*NOTE: This program outputs a .ppm image file. Please use a valid PPM image viewer or convert said image to PNG/JPG for viewing. The output.png file in this repo is only meant for displaying in this README.*

* Arguments used for this sample: 1280 720 500 50

## Changes
- Entire project is re-written in vlang, without any dependencies other than vlang's own builtin modules (essentially its standard library).

- Most if not all algorithms used are kept the same, just rewritten in V instead.
  - There are a small handful of functions used in the book that I do not agree with when it comes to its implementation, so minor changes have been applied with performance in mind.

## Usage
Once [vlang](https://vlang.io/) has been setup for you, checkout this repo and run the following command in the root directory. It should not produce any warnings
```
v run .
```
You can specify the output image width, height, iteration sample and depth count by appending the arguments after the above command. Eg.
```
v run . 512 288 500 50
```
The default values for the arguments are used if none are specified
- width: 512
- height: 288
- sample: 500
- depth: 50

To build an executable, run the following command
```
v -prod .
```
The `-prod` flag indicates production mode, meaning the executable will not be built with TCC, leading to a more optimized bytecode. You can then run the executable with the same arguments by running
```
./vray . 512 288 500 50
```

### Generating C code
[vlang](https://vlang.io/) has a feature where it can generate the C code that will be used for compilation, you can get it by running the following command in the root directory. Do note that
```
v . -o vray.c
```
