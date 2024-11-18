const std = @import("std");
const builtin = @import("builtin");
const gl = @import("gl");
const glfw = @import("glfw/mod.zig");
const Renderer = @import("renderer/Renderer.zig");
const debugCallback = Renderer.debugCallback;

var procs: gl.ProcTable = undefined;

pub fn main() !void {
    try glfw.init(.{});
    defer glfw.terminate();

    const window = try glfw.Window.create(800, 600, "lotus", .{
        // .resizable = false,
        .opengl_forward_compat = true,
        .context_debug = builtin.mode == .Debug,
    });
    defer window.destroy();

    window.setFramebufferSizeCallback(@ptrCast(&Renderer.fbSizeCallback));

    glfw.makeContextCurrent(window);
    defer glfw.makeContextCurrent(null);

    if (!procs.init(glfw.getProcAddress)) return error.InitProcsFailed;

    gl.makeProcTableCurrent(&procs);
    defer gl.makeProcTableCurrent(null);

    if (builtin.mode == .Debug)
        gl.DebugMessageCallback(@ptrCast(&debugCallback), null);

    var renderer = try Renderer.create();
    defer renderer.destroy();

    while (!window.shouldClose()) {
        renderer.drawFrame();
        window.swapBuffers();
        glfw.pollEvents();
    }
}
