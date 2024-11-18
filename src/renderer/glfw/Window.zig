const std = @import("std");
const gl = @import("gl");
const glfw = @import("../glfw.zig");
const c = @import("c.zig").c;

const Window = @This();

const Hints = struct {
    context_creation_api: ContextCreationApi = .native_context_api,
    context_no_error: bool = false,
    context_debug: bool = false,
    opengl_forward_compat: bool = false,

    resizable: bool = true,

    wayland_app_id: [:0]const u8 = "",

    x11_class_name: [:0]const u8 = "",
    x11_instance_name: [:0]const u8 = "",

    fn set(hints: Hints) void {
        inline for (comptime std.meta.fieldNames(Hint)) |field_name| {
            const tag = @intFromEnum(@field(Hint, field_name));
            const val = @field(hints, field_name);

            switch (@TypeOf(val)) {
                bool => c.glfwWindowHint(tag, @intFromBool(val)),
                ContextCreationApi => c.glfwWindowHint(tag, @intFromEnum(val)),
                [:0]const u8 => c.glfwWindowHintString(tag, val.ptr),
                else => unreachable,
            }
        }
    }
};

const Hint = enum(c_int) {
    context_creation_api = c.GLFW_CONTEXT_CREATION_API,
    context_no_error = c.GLFW_CONTEXT_NO_ERROR,
    context_debug = c.GLFW_CONTEXT_DEBUG,
    opengl_forward_compat = c.GLFW_OPENGL_FORWARD_COMPAT,

    resizable = c.GLFW_RESIZABLE,

    wayland_app_id = c.GLFW_WAYLAND_APP_ID,

    x11_class_name = c.GLFW_X11_CLASS_NAME,
    x11_instance_name = c.GLFW_X11_INSTANCE_NAME,
};

const ContextCreationApi = enum(c_int) {
    native_context_api = c.GLFW_NATIVE_CONTEXT_API,
    egl_context_api = c.GLFW_EGL_CONTEXT_API,
    osmesa_context_api = c.GLFW_OSMESA_CONTEXT_API,
};

pub const Handle = *c.GLFWwindow;

handle: Handle,

pub fn create(
    width: u32,
    height: u32,
    title: [*:0]const u8,
    hints: Hints,
) glfw.Error!Window {
    hints.set();
    hintApiInfo();

    const handle = c.glfwCreateWindow(@intCast(width), @intCast(height), title, null, null) orelse return glfw.getError();

    return .{ .handle = handle };
}

fn from(handle: *c.GLFWwindow) Window {
    return Window{ .handle = handle };
}

fn hintApiInfo() void {
    c.glfwWindowHint(c.GLFW_CLIENT_API, switch (gl.info.api) {
        .gl => c.GLFW_OPENGL_API,
        .gles => c.GLFW_OPENGL_ES_API,
        .glsc => @compileError("unsupported API"),
    });

    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, gl.info.version_major);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, gl.info.version_minor);
    if (gl.info.profile) |profile| {
        c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, switch (profile) {
            .core => c.GLFW_OPENGL_CORE_PROFILE,
            .compatibility => c.GLFW_OPENGL_COMPAT_PROFILE,
            else => c.GLFW_OPENGL_ANY_PROFILE,
        });
    }
}

pub fn destroy(self: Window) void {
    c.glfwDestroyWindow(self.handle);
}

pub fn setFramebufferSizeCallback(
    self: Window,
    comptime callback: c.GLFWframebuffersizefun,
) void {
    _ = c.glfwSetFramebufferSizeCallback(self.handle, callback);
}

pub fn shouldClose(self: Window) bool {
    return c.glfwWindowShouldClose(self.handle) == c.GLFW_TRUE;
}

pub fn setShouldClose(self: Window, val: bool) void {
    c.glfwSetWindowShouldClose(self.handle, @intFromBool(val));
}

pub fn swapBuffers(self: Window) void {
    c.glfwSwapBuffers(self.handle);
}
