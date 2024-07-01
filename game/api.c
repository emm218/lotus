#include <lotus/api.h>
#include <lotus/logging.h>
#include <stdarg.h>

game_update_f update;
get_app_info_f get_app_info;
setup_f setup;

static engine_api engine;

engine_api *
get_api(game_api *game)
{
	game->update = update;
	game->get_app_info = get_app_info;
	game->setup = setup;

	return &engine;
}

void
_log_output(const char *msg, ...)
{
	va_list arg_ptr;
	va_start(arg_ptr, msg);
	engine._vlog_output(msg, arg_ptr);
	va_end(arg_ptr);
}
