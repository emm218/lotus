const std = @import("std");
const gl = @import("gl");
const log = std.log;

const ShaderProgram = @This();
const Id = gl.uint;

const ShaderType = enum(comptime_int) {
    vertex = gl.VERTEX_SHADER,
    fragment = gl.FRAGMENT_SHADER,
};

vertex: Id,
fragment: Id,
id: Id,

threadlocal var info_log: [512]u8 = undefined;

pub fn create(vertex_source: [:0]const u8, fragment_source: [:0]const u8) !ShaderProgram {
    const vertex = try compileShader(.vertex, vertex_source);
    errdefer gl.DeleteShader(vertex);

    const fragment = try compileShader(.fragment, fragment_source);
    errdefer gl.DeleteShader(fragment);

    const program = gl.CreateProgram();
    if (program == 0) return error.CreateProgramFailed;
    errdefer gl.DeleteProgram(program);

    gl.AttachShader(program, vertex);
    gl.AttachShader(program, fragment);
    gl.LinkProgram(program);
    var success: gl.int = undefined;
    gl.GetProgramiv(program, gl.LINK_STATUS, &success);
    if (success == gl.FALSE) {
        gl.GetProgramInfoLog(program, info_log.len, null, &info_log);
        log.err("{s}\n", .{info_log});
        return error.LinkFailed;
    }

    return .{
        .vertex = vertex,
        .fragment = fragment,
        .id = program,
    };
}

pub fn destroy(self: ShaderProgram) void {
    gl.DeleteShader(self.fragment);
    gl.DeleteShader(self.vertex);
    gl.DeleteProgram(self.id);
}

pub fn use(self: ShaderProgram) void {
    gl.UseProgram(self.id);
}

fn compileShader(shader_type: ShaderType, source: [:0]const u8) !Id {
    const shader = gl.CreateShader(@intFromEnum(shader_type));
    if (shader == 0) return error.CreateShaderFailed;

    gl.ShaderSource(shader, 1, @ptrCast(&source), null);
    gl.CompileShader(shader);

    var success: gl.int = undefined;
    gl.GetShaderiv(shader, gl.COMPILE_STATUS, &success);
    if (success == gl.FALSE) {
        gl.GetShaderInfoLog(shader, info_log.len, null, &info_log);
        log.err("{s}\n", .{info_log});
        return error.CompilationFailed;
    }

    return shader;
}
