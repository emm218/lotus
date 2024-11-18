const std = @import("std");
const gl = @import("gl");

pub const debugCallback = @import("debug.zig").callback;

const buffers = @import("buffers.zig");
const Vbo = buffers.Vbo;
const ShaderProgram = @import("ShaderProgram.zig");
const Vao = @import("Vao.zig");
const bufferData = buffers.bufferData;
const vertexAttribPointer = Vao.vertexAttribPointer;

const Renderer = @This();

program: ShaderProgram,
vao: Vao,
vbo: Vbo,

pub fn create() !Renderer {
    const program = try ShaderProgram.create(VERTEX_SOURCE, FRAGMENT_SOURCE);
    errdefer program.destroy();

    var vao = try Vao.create();
    errdefer vao.destroy();
    vao.bind();

    var vbo = try Vbo.create();
    errdefer vbo.destroy();
    vbo.bind(.array_buffer);

    gl.EnableVertexAttribArray(0);
    vertexAttribPointer(0, 2, f32, false, @sizeOf(Vertex), 0);

    bufferData(&VERTEX_DATA, .array_buffer, .static_draw);

    return .{
        .vao = vao,
        .vbo = vbo,
        .program = program,
    };
}

pub fn destroy(self: *Renderer) void {
    self.program.destroy();
    self.vao.destroy();
    self.vbo.destroy();
}

pub fn drawFrame(self: Renderer) void {
    gl.ClearBufferfv(gl.COLOR, 0, &[4]f32{ 0.0, 0.0, 1.0, 1.0 });

    self.vao.bind();
    self.program.use();

    drawArrays(.triangles, 0, VERTEX_DATA.len);
}

const DrawMode = enum(comptime_int) {
    triangles = gl.TRIANGLES,
};

fn drawArrays(mode: DrawMode, first: gl.int, count: gl.sizei) void {
    gl.DrawArrays(@intFromEnum(mode), first, count);
}

const Vertex = struct {
    x: f32,
    y: f32,
};

const VERTEX_DATA = [_]Vertex{
    .{ .x = -0.5, .y = 0.5 },
    .{ .x = 0.5, .y = 0.5 },
    .{ .x = 0.0, .y = -0.5 },
};

const VERTEX_SOURCE = @embedFile("shaders/triangle.vs");
const FRAGMENT_SOURCE = @embedFile("shaders/triangle.fs");

pub fn fbSizeCallback(
    _: ?*anyopaque,
    width: c_int,
    height: c_int,
) callconv(.C) void {
    gl.Viewport(0, 0, width, height);
}
