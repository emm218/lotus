const std = @import("std");
const gl = @import("gl");

pub const debugCallback = @import("debug.zig").callback;

const buffers = @import("buffers.zig");
const Vbo = buffers.Vbo;
const ShaderProgram = @import("ShaderProgram.zig");
const Vao = @import("Vao.zig");
const bufferData = buffers.bufferData;
const unbindBuffer = buffers.unbindBuffer;
const unbindVertexArray = Vao.unbindVertexArray;
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

    vertexAttribPointer(0, 2, f32, false, @sizeOf(Vertex), 0);
    gl.EnableVertexAttribArray(0);

    vertexAttribPointer(1, 3, u8, true, @sizeOf(Vertex), @offsetOf(Vertex, "r"));
    gl.EnableVertexAttribArray(1);

    bufferData(&VERTEX_DATA, .array_buffer, .static_draw);

    unbindBuffer(.array_buffer);
    unbindVertexArray();

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
    gl.ClearBufferfv(gl.COLOR, 0, &[4]f32{ 0.0, 0.0, 0.0, 1.0 });

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

const Vertex = extern struct {
    x: f32,
    y: f32,
    r: u8 = 0,
    g: u8 = 0,
    b: u8 = 0,
};

const VERTEX_DATA = [_]Vertex{
    .{ .x = -0.5, .y = 0.5, .r = 255, .g = 255 },
    .{ .x = 0.5, .y = 0.5, .g = 255, .b = 255 },
    .{ .x = 0.0, .y = -0.5, .r = 255, .b = 255 },
};

const VERTEX_SOURCE = @embedFile("shaders/triangle.vert");
const FRAGMENT_SOURCE = @embedFile("shaders/triangle.frag");

pub fn fbSizeCallback(
    _: ?*anyopaque,
    width: c_int,
    height: c_int,
) callconv(.C) void {
    gl.Viewport(0, 0, width, height);
}
