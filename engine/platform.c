/*
 * Copyright (C) 2024 emmy emmycelium
 *
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Affero General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more
 * details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */
#define GLFW_INCLUDE_NONE
#include <GLFW/glfw3.h>
#include <engine/logging.h>
#include <glad/glad.h>

#include "platform.h"
#include "renderer.h"

#define GL_MAJOR 4
#define GL_MINOR 2

static void error_callback(int, const char *);
static void framebuffer_size_callback(GLFWwindow *, int, int);
static void GLAPIENTRY msg_callback(GLenum, GLenum, GLuint, GLenum, GLsizei,
    const GLchar *, const void *);

static GLFWwindow *window;

int
init_window(app_info *info)
{
	if (!glfwInit()) {
		FATAL("failed to initialize GLFW");
		return 1;
	}

	glfwSetErrorCallback(error_callback);

	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, GL_MAJOR);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, GL_MINOR);
#ifdef DEBUG_FLAG
	glfwWindowHint(GLFW_OPENGL_DEBUG_CONTEXT, GLFW_TRUE);
#endif

	window = glfwCreateWindow(info->width, info->height, info->app_name,
	    NULL, NULL);
	if (!window) {
		FATAL("window creation failed");
		glfwTerminate();
		return 1;
	}

	glfwMakeContextCurrent(window);
	if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
		FATAL("failed to load OpenGL");
		shutdown_window();
		return 1;
	}

	INFO("OpenGL version %s", glGetString(GL_VERSION));

#ifdef DEBUG_FLAG
	glEnable(GL_DEBUG_OUTPUT);
	glDebugMessageCallback(msg_callback, NULL);
#endif
	glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);

	return 0;
}

void
shutdown_window(void)
{
	glfwDestroyWindow(window);
	glfwTerminate();
}

int
should_close(void)
{
	return glfwWindowShouldClose(window);
}

void
request_close(void)
{
	glfwSetWindowShouldClose(window, GLFW_TRUE);
}

void
swap_buffers(void)
{
	glfwSwapBuffers(window);
}

void
poll_events(void)
{
	glfwPollEvents();
}

static void
error_callback(int error, const char *description)
{
	ERROR_SRC("glfw", "%s (%d)", description, error);
}

static void
framebuffer_size_callback(GLFWwindow *window, int width, int height)
{
	(void)window;

	resize_renderer(width, height);
}

#define GL_LOG_STRING(s) "\033[90m[" s "\033[90m]\033[0m GL:%s\t%s"

#define GL_ERROR(src, msg) _log_output(GL_LOG_STRING("\033[31mERROR"), src, msg)

#if LOG_LEVEL >= LOG_WARN
#define GL_WARN(src, msg) _log_output(GL_LOG_STRING("\033[33mWARN "), src, msg)
#else
#define GL_WARN(message, ...)
#endif

#if LOG_LEVEL >= LOG_INFO
#define GL_INFO(src, msg) _log_output(GL_LOG_STRING("\033[32mINFO "), src, msg)
#else
#define GL_INFO(message, ...)
#endif

static void GLAPIENTRY
msg_callback(GLenum source, GLenum type, GLuint id, GLenum severity,
    GLsizei length, const GLchar *msg, const void *data)
{
	(void)data;
	(void)type;
	(void)id;
	(void)length;

	char *src = "";

	switch (source) {
	case GL_DEBUG_SOURCE_API:
		src = "api";
	case GL_DEBUG_SOURCE_WINDOW_SYSTEM:
		src = "window system";
	case GL_DEBUG_SOURCE_SHADER_COMPILER:
		src = "compiler";
	case GL_DEBUG_SOURCE_THIRD_PARTY:
		src = "third party";
	case GL_DEBUG_SOURCE_APPLICATION:
		src = "application";
	}

	switch (severity) {
	case GL_DEBUG_SEVERITY_HIGH:
		GL_ERROR(src, msg);
		break;
	case GL_DEBUG_SEVERITY_MEDIUM:
	case GL_DEBUG_SEVERITY_LOW:
		GL_WARN(src, msg);
		break;
	case GL_DEBUG_SEVERITY_NOTIFICATION:
		GL_INFO(src, msg);
		break;
	}
}
