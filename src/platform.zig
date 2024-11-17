const builtin = @import("builtin");

pub const Platform = Interface(switch (builtin.os.tag) {
    .linux => @import("platform/Linux.zig"),
    else => @compileError("unsupported platform"),
});

// checks that all fields are available for a given platform interface
//
// thanks to mach devs for the idea and the assertDecl code :)
fn Interface(comptime T: type) type {
    return T;
}

fn assertDecl(comptime T: anytype, comptime name: []const u8, comptime Decl: type) void {
    if (!@hasDecl(T, name)) {
        @compileError("platform missing declaration: " ++ @typeName(Decl));
    }
    const FoundDecl = @TypeOf(@field(T, name));
    if (FoundDecl != Decl) {
        @compileError("platform field '" ++ name ++ "'\n\texpected type: " ++ @typeName(Decl) ++ "\n\t   found type: " ++ @typeName(FoundDecl));
    }
}
