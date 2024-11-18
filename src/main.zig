const std = @import("std");
const gl = @import("gl");
const glfw = @import("glfw.zig");

var procs: gl.ProcTable = undefined;

pub fn main() !void {
    try glfw.init(.{});
    defer glfw.terminate();

    const window = try glfw.Window.create(800, 600, "lotus", .{
        .resizable = false,
        .opengl_forward_compat = true,
    });
    defer window.destroy();

    window.setFramebufferSizeCallback(&framebufferSizeCallback);

    glfw.makeContextCurrent(window);
    defer glfw.makeContextCurrent(null);

    if (!procs.init(glfw.getProcAddress)) return error.InitProcsFailed;

    gl.makeProcTableCurrent(&procs);
    defer gl.makeProcTableCurrent(null);

    while (!window.shouldClose()) {
        gl.ClearBufferfv(gl.COLOR, 0, &[4]f32{ 0.0, 0.0, 1.0, 1.0 });

        window.swapBuffers();
        glfw.pollEvents();
    }
}

fn framebufferSizeCallback(
    window: ?glfw.Window.Handle,
    width: c_int,
    height: c_int,
) callconv(.C) void {
    _ = window;

    gl.Viewport(0, 0, width, height);
}
