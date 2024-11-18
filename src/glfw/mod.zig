//!
//! ziggy glfw API. Mostly based on mach-glfw but I didn't feel like messing
//! with mach's zig version requirements and this way I can just add glfw
//! features as I need them.
//!

const std = @import("std");
const gl = @import("gl");
const c = @import("c.zig").c;
const errors = @import("errors.zig");

pub const Window = @import("Window.zig");
pub const Error = errors.Error;
pub const getError = errors.getError;

/// glfw init hints
pub const Hints = struct {
    platform: PlatformType = .any,
    wayland_libdecor: WaylandLibDecorHint = .wayland_prefer_libdecor,
    x11_xcb_vulkan_surface: bool = true,

    fn set(hints: Hints) void {
        inline for (comptime std.meta.fieldNames(Hint)) |field_name| {
            const tag = @intFromEnum(@field(Hint, field_name));
            const val = @field(hints, field_name);

            switch (@TypeOf(val)) {
                bool => c.glfwInitHint(tag, @intFromBool(val)),

                PlatformType,
                WaylandLibDecorHint,
                => c.glfwInitHint(tag, @intFromEnum(val)),
                else => unreachable,
            }
        }
    }
};

const Hint = enum(c_int) {
    platform = c.GLFW_PLATFORM,
    wayland_libdecor = c.GLFW_WAYLAND_LIBDECOR,
    x11_xcb_vulkan_surface = c.GLFW_X11_XCB_VULKAN_SURFACE,
};

pub const WaylandLibDecorHint = enum(c_int) {
    wayland_prefer_libdecor = c.GLFW_WAYLAND_PREFER_LIBDECOR,
    wayland_disable_libdecor = c.GLFW_WAYLAND_DISABLE_LIBDECOR,
};

pub const PlatformType = enum(c_int) {
    any = c.GLFW_ANY_PLATFORM,
    win32 = c.GLFW_PLATFORM_WIN32,
    cocoa = c.GLFW_PLATFORM_COCOA,
    wayland = c.GLFW_PLATFORM_WAYLAND,
    x11 = c.GLFW_PLATFORM_X11,
    null = c.GLFW_PLATFORM_NULL,
};

pub fn init(hints: Hints) Error!void {
    hints.set();
    if (c.glfwInit() != c.GLFW_TRUE) return getError();
}

pub const terminate = c.glfwTerminate;
pub const getProcAddress = c.glfwGetProcAddress;

pub fn pollEvents() void {
    c.glfwPollEvents();
}

pub fn getPlatform() PlatformType {
    return @enumFromInt(c.glfwGetPlatform());
}

pub fn makeContextCurrent(window: ?Window) void {
    if (window) |w|
        c.glfwMakeContextCurrent(w.handle)
    else
        c.glfwMakeContextCurrent(null);
}
