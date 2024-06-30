/*
 * Copyright (C) 2024 Emmy Emmycelium
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
