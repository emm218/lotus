const std = @import("std");
const Platform = @import("platform.zig").Platform;
const glfw = @import("glfw.zig");
const Renderer = @import("Renderer.zig");

pub fn main() !void {
    try glfw.init();
    defer glfw.terminate();

    const window = try glfw.createWindow(800, 600, "meower");

    const renderer = try Renderer.init();

    while (!window.shouldClose()) {
        try renderer.drawFrame();
        window.swapBuffers();
        glfw.pollEvents();
    }
}
