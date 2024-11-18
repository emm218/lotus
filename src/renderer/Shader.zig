const std = @import("std");
const gl = @import("gl");
const log = std.log;

const Self = @This();

vertex: gl.uint,
fragment: gl.uint,
program: gl.uint,

var info_log: [512]u8 = undefined;

pub fn create(vertex_source: [:0]const u8, fragment_source: [:0]const u8) !Self {
    const vertex = try compileShader(.vertex, vertex_source);
    errdefer {
        gl.DeleteShader(vertex);
    }

    const fragment = try compileShader(.fragment, fragment_source);
    errdefer {
        gl.DeleteShader(fragment);
    }

    const program = gl.CreateProgram();
    if (program == 0) return error.CreateProgramFailed;
    errdefer {
        gl.DeleteProgram(program);
    }
    gl.AttachShader(program, vertex);
    gl.AttachShader(program, fragment);
    gl.LinkProgram(program);

    var success: gl.int = undefined;
    gl.GetProgramiv(program, gl.LINK_STATUS, &success);
    if (success == gl.FALSE) {
        gl.GetProgramInfoLog(program, info_log.len, null, &info_log);
        log.err("{s}\n", .{info_log});
        return error.ShaderLinkFailed;
    }

    return .{
        .vertex = vertex,
        .fragment = fragment,
        .program = program,
    };
}

pub fn use(self: Self) void {
    gl.UseProgram(self.program);
}

pub fn destroy(self: *Self) void {
    gl.DeleteProgram(self.program);
    gl.DeleteShader(self.fragment);
    gl.DeleteShader(self.vertec);

    self.* = std.mem.zeroes(Self);
}

const ShaderType = enum(comptime_int) {
    vertex = gl.VERTEX_SHADER,
    fragment = gl.FRAGMENT_SHADER,
};

fn compileShader(shader_type: ShaderType, source: [:0]const u8) !gl.uint {
    const shader = gl.CreateShader(@intFromEnum(shader_type));
    if (shader == 0) return error.CreateShaderFailed;
    gl.ShaderSource(shader, 1, @ptrCast(&source), null);
    gl.CompileShader(shader);

    var success: gl.int = undefined;
    gl.GetShaderiv(shader, gl.COMPILE_STATUS, &success);
    if (success == gl.FALSE) {
        gl.GetShaderInfoLog(shader, info_log.len, null, &info_log);
        log.err("{s}\n", .{info_log});
        return error.ShaderCompilationFailed;
    }
    return shader;
}
