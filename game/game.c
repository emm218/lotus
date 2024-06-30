#include <engine/api.h>
#include <engine/logging.h>

#include "engine.h"

engine_api engine;

game_update_f update;
get_app_info_f get_app_info;

engine_api *
get_api(game_api *game)
{
	game->update = &update;
	game->get_app_info = &get_app_info;

	return &engine;
}

void
update(long frame_num)
{
	(void)frame_num;
}

app_info
get_app_info(void)
{
	INFO("meow from the game!");
	return (app_info) {
		.app_name = "lotus-test",
		.width = 800,
		.height = 600,
	};
}
