#include <engine/logging.h>
#include <stdarg.h>

#include "engine.h"

void
_log_output(const char *msg, ...)
{
	va_list arg_ptr;
	va_start(arg_ptr, msg);
	engine._log_output(msg, arg_ptr);
	va_end(arg_ptr);
}
