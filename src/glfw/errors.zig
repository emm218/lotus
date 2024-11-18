const c = @import("c.zig").c;

pub const Error = error{
    NoError,
    NotInitialized,
    NoCurrentContext,
    InvalidEnum,
    InvalidValue,
    OutOfMemory,
    APIUnavailable,
    VersionUnavailable,
    PlatformError,
    FormatUnavailable,
    NoWindowContext,
    CursorUnavailable,
    FeatureUnavailable,
    FeatureUnimplemented,
    PlatformUnavailable,
};

fn convertError(e: c_int) Error {
    return switch (e) {
        c.GLFW_NO_ERROR => Error.NoError,
        c.GLFW_NOT_INITIALIZED => Error.NotInitialized,
        c.GLFW_NO_CURRENT_CONTEXT => Error.NoCurrentContext,
        c.GLFW_INVALID_ENUM => Error.InvalidEnum,
        c.GLFW_INVALID_VALUE => Error.InvalidValue,
        c.GLFW_OUT_OF_MEMORY => Error.OutOfMemory,
        c.GLFW_API_UNAVAILABLE => Error.APIUnavailable,
        c.GLFW_VERSION_UNAVAILABLE => Error.VersionUnavailable,
        c.GLFW_PLATFORM_ERROR => Error.PlatformError,
        c.GLFW_FORMAT_UNAVAILABLE => Error.FormatUnavailable,
        c.GLFW_NO_WINDOW_CONTEXT => Error.NoWindowContext,
        c.GLFW_CURSOR_UNAVAILABLE => Error.CursorUnavailable,
        c.GLFW_FEATURE_UNAVAILABLE => Error.FeatureUnavailable,
        c.GLFW_FEATURE_UNIMPLEMENTED => Error.FeatureUnimplemented,
        c.GLFW_PLATFORM_UNAVAILABLE => Error.PlatformUnavailable,
        else => unreachable,
    };
}

pub fn getError() Error {
    return convertError(c.glfwGetError(null));
}
