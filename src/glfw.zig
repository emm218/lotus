const std = @import("std");
const gl = @import("gl");
const c = @cImport({
    @cDefine("GLFW_INCLUDE_NONE", "1");
    @cInclude("GLFW/glfw3.h");
});

var procs: gl.ProcTable = undefined;

pub fn init() !void {
    if (c.glfwInit() != c.GLFW_TRUE) {
        return error.GlfwInitFailed;
    }

    c.glfwWindowHint(c.GLFW_CLIENT_API, c.GLFW_OPENGL_ES_API);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 2);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 0);
}

pub const terminate = c.glfwTerminate;

pub const Window = struct {
    const Self = @This();

    inner: *c.GLFWwindow,

    pub inline fn swapBuffers(self: Self) void {
        c.glfwSwapBuffers(self.inner);
    }

    pub inline fn shouldClose(self: Self) bool {
        return c.glfwWindowShouldClose(self.inner) != 0;
    }
};

pub fn createWindow(width: u32, height: u32, title: [:0]const u8) !Window {
    const glfw_window = c.glfwCreateWindow(
        @intCast(width),
        @intCast(height),
        title,
        null,
        null,
    ) orelse return error.WindowCreationFailed;

    _ = c.glfwSetWindowSizeCallback(glfw_window, &resizeCallback);
    c.glfwMakeContextCurrent(glfw_window);

    if (!procs.init(c.glfwGetProcAddress)) return error.InitProcsFailed;

    gl.makeProcTableCurrent(&procs);

    return Window{ .inner = glfw_window };
}

fn resizeCallback(window: ?*c.GLFWwindow, width: c_int, height: c_int) callconv(.C) void {
    _ = window;
    gl.Viewport(0, 0, width, height);
}

pub const pollEvents = c.glfwPollEvents;
