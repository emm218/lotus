const std = @import("std");
const gl = @import("gl");
const Id = gl.uint;

pub const Usage = enum(comptime_int) {
    static_draw = gl.STATIC_DRAW,
    stream_draw = gl.STREAM_DRAW,
    dynamic_draw = gl.DYNAMIC_DRAW,
};

pub const Target = enum(comptime_int) {
    array_buffer = gl.ARRAY_BUFFER,
};

pub const Vbo = struct {
    id: Id,

    pub fn create() !Vbo {
        var id: Id = undefined;
        gl.GenBuffers(1, @ptrCast(&id));
        if (id == 0) return error.GenBuffersFailed;
        return .{ .id = id };
    }

    pub fn destroy(self: *Vbo) void {
        gl.DeleteBuffers(1, @ptrCast(&self.id));
    }

    pub fn bind(self: Vbo, target: Target) void {
        gl.BindBuffer(@intFromEnum(target), self.id);
    }
};

pub fn unbindBuffer(target: Target) void {
    gl.BindBuffer(@intFromEnum(target), 0);
}

pub fn bufferData(buffer: anytype, target: Target, usage: Usage) void {
    const Slice = @typeInfo(@TypeOf(buffer)).Pointer;
    const T = Slice.child;

    const size = @sizeOf(T) * buffer.len;

    gl.BufferData(@intFromEnum(target), size, buffer.ptr, @intFromEnum(usage));
}
