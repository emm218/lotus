const std = @import("std");
const gl = @import("gl");

const Renderer = @This();

// placeholders...

pub fn create() Renderer {
    return .{};
}

pub fn destroy(self: Renderer) void {
    _ = self;
}

pub fn drawFrame(self: Renderer) void {
    gl.ClearBufferfv(gl.COLOR, 0, &[4]f32{ 0.0, 0.0, 1.0, 1.0 });
    _ = self;
}

pub fn fbSizeCallback(
    handle: ?*anyopaque,
    width: c_int,
    height: c_int,
) callconv(.C) void {
    _ = handle;

    gl.Viewport(0, 0, width, height);
}
