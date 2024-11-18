const std = @import("std");
const gl = @import("gl");
const glfw = @import("renderer/glfw.zig");
const Window = glfw.Window;

const Renderer = @This();

// placeholders...

pub fn create() Renderer {
    return .{};
}

pub fn destroy(self: Renderer) void {
    _ = self;
}

pub inline fn shouldClose(self: Renderer) bool {
    return self.window.shouldClose();
}

pub fn drawFrame(self: Renderer) void {
    gl.ClearBufferfv(gl.COLOR, 0, &[4]f32{ 0.0, 0.0, 1.0, 1.0 });
    _ = self;
}

pub fn fbSizeCallback(
    handle: ?glfw.Window.Handle,
    width: c_int,
    height: c_int,
) callconv(.C) void {
    _ = handle;

    gl.Viewport(0, 0, width, height);
}
