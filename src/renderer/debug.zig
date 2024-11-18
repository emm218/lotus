const std = @import("std");
const log = std.log.scoped(.gl);
const gl = @import("gl");

const GlDebugSource = enum(gl.@"enum") {
    api = gl.DEBUG_SOURCE_API,
    window_system = gl.DEBUG_SOURCE_WINDOW_SYSTEM,
    shader_compiler = gl.DEBUG_SOURCE_SHADER_COMPILER,
    third_party = gl.DEBUG_SOURCE_THIRD_PARTY,
    application = gl.DEBUG_SOURCE_APPLICATION,
    other = gl.DEBUG_SOURCE_OTHER,
};

const GlDebugType = enum(gl.@"enum") {
    @"error" = gl.DEBUG_TYPE_ERROR,
    deprecated = gl.DEBUG_TYPE_DEPRECATED_BEHAVIOR,
    undefined = gl.DEBUG_TYPE_UNDEFINED_BEHAVIOR,
    portability = gl.DEBUG_TYPE_PORTABILITY,
    performance = gl.DEBUG_TYPE_PERFORMANCE,
    marker = gl.DEBUG_TYPE_MARKER,
    push_group = gl.DEBUG_TYPE_PUSH_GROUP,
    pop_group = gl.DEBUG_TYPE_POP_GROUP,
    other = gl.DEBUG_TYPE_OTHER,
};

const GlDebugSeverity = enum(gl.@"enum") {
    high = gl.DEBUG_SEVERITY_HIGH,
    medium = gl.DEBUG_SEVERITY_MEDIUM,
    low = gl.DEBUG_SEVERITY_LOW,
    notification = gl.DEBUG_SEVERITY_NOTIFICATION,
};

pub fn callback(
    _: GlDebugSource,
    _: GlDebugType,
    _: gl.uint,
    severity: GlDebugSeverity,
    _: gl.sizei,
    msg: [*c]u8,
    _: ?*anyopaque,
) callconv(.C) void {
    switch (severity) {
        .notification => log.info("{s}", .{msg}),
        .low, .medium => log.warn("{s}", .{msg}),
        .high => log.err("{s}", .{msg}),
    }
}
