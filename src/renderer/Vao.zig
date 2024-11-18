const gl = @import("gl");

const Vao = @This();

const Id = gl.uint;

id: Id,

pub fn create() !Vao {
    var id: Id = undefined;
    gl.GenVertexArrays(1, @ptrCast(&id));
    if (id == 0) return error.GenArraysFailed;
    return .{ .id = id };
}

pub fn destroy(self: *Vao) void {
    gl.DeleteVertexArrays(1, @ptrCast(&self.id));
}

pub fn bind(self: Vao) void {
    gl.BindVertexArray(self.id);
}

pub fn vertexAttribPointer(
    index: gl.uint,
    size: gl.int,
    comptime T: type,
    normalized: bool,
    stride: usize,
    offset: usize,
) void {
    gl.VertexAttribPointer(index, size, glType(T), @intFromBool(normalized), @intCast(stride), offset);
}

fn glType(comptime T: type) comptime_int {
    return switch (T) {
        i8 => gl.BYTE,
        i16 => gl.SHORT,
        i32 => gl.INT,
        u8 => gl.UNSIGNED_BYTE,
        u16 => gl.UNSIGNED_SHORT,
        u32 => gl.UNSIGNED_INT,
        f16 => gl.HALF_FLOAT,
        f32 => gl.FLOAT,
        f64 => gl.DOUBLE,
        else => @compileError("no GL type corresponding to type" ++ @typeName(T)),
    };
}
