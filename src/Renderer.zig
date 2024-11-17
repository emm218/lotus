const gl = @import("gl");
const Self = @This();

pub fn init() !Self {
    return .{};
}

pub fn draw_frame(self: *const Self) !void {
    gl.ClearColor(0.0, 0.0, 1.0, 1.0);
    gl.Clear(gl.COLOR_BUFFER_BIT);

    _ = self;
}
