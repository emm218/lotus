const std = @import("std");
const gl = @import("gl");
const Shader = @import("renderer/Shader.zig");

const Self = @This();

const GlUsage = enum(comptime_int) {
    static_draw = gl.STATIC_DRAW,
    stream_draw = gl.STREAM_DRAW,
    dynamic_draw = gl.DYNAMIC_DRAW,
};

const GlBufferTarget = enum(comptime_int) {
    array_buffer = gl.ARRAY_BUFFER,
};

const Vertex = struct {
    x: f32,
    y: f32,
};

const Vbo = struct {
    id: gl.uint = 0,

    fn init(buffer: *Vbo) !void {
        gl.GenBuffers(1, @ptrCast(&buffer.id));
        if (buffer.id == 0) return error.GenBuffersFailed;
    }

    fn init_many(buffers: []Vbo) !void {
        gl.GenBuffers(buffers.len, @ptrCast(buffers.ptr));
        for (buffers) |buffer| {
            if (buffer.id == 0) return error.GenBuffersFailed;
        }
    }

    fn bind(self: Vbo, target: GlBufferTarget) void {
        gl.BindBuffer(@intFromEnum(target), self.id);
    }
};

fn bufferData(comptime T: type, target: GlBufferTarget, buffer: []const T, usage: GlUsage) void {
    gl.BufferData(
        @intFromEnum(target),
        @intCast(@sizeOf(T) * buffer.len),
        @ptrCast(buffer),
        @intFromEnum(usage),
    );
}

var vbo: Vbo = .{};
var program: Shader = undefined;
const vertex_data = [_]Vertex{
    .{ .x = -0.5, .y = 0.5 },
    .{ .x = 0.5, .y = 0.5 },
    .{ .x = 0.0, .y = -0.5 },
};

pub fn init() !Self {
    try vbo.init();

    vbo.bind(.array_buffer);
    bufferData(Vertex, .array_buffer, &vertex_data, .static_draw);

    gl.VertexAttribPointer(0, 2, gl.FLOAT, gl.FALSE, @sizeOf(Vertex), 0);
    gl.EnableVertexAttribArray(0);

    program = try Shader.create(VERTEX_SOURCE, FRAG_SOURCE);

    return .{};
}

const GlDrawMode = enum(comptime_int) {
    triangles = gl.TRIANGLES,
};

fn drawArrays(mode: GlDrawMode, first: gl.int, count: gl.sizei) void {
    gl.DrawArrays(@intFromEnum(mode), first, count);
}

pub fn drawFrame(self: *const Self) !void {
    gl.ClearColor(0.0, 0.0, 1.0, 1.0);
    gl.Clear(gl.COLOR_BUFFER_BIT);

    vbo.bind(.array_buffer);
    program.use();
    drawArrays(.triangles, 0, 3);

    _ = self;
}

const VERTEX_SOURCE = @embedFile("renderer/shaders/triangle.vs");
const FRAG_SOURCE = @embedFile("renderer/shaders/triangle.fs");
