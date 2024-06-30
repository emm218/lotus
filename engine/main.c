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
#include <dlfcn.h>
#include <engine/api.h>
#include <stdlib.h>

#include "logging.h"
#include "platform.h"
#include "renderer.h"

#define VERSION "0.1.0"

static void *load_game(const char *, game_api *, void *);

game_api game;

int
main(void)
{
	app_info app;
	INFO("lotus engine v" VERSION);

	load_game("target/game.so", &game, NULL);

	app = game.get_app_info();
	INFO("loaded %s", app.app_name);

	init_window(&app);

	while (!should_close()) {
		poll_events();
		start_frame();
		end_frame();
	}

	shutdown_window();

	return 0;
}

static void *
load_game(const char *lib_path, game_api *game, void *old_lib)
{
	void *lib_handle;
	get_game_api *get_api;
	engine_api *engine;

	INFO("loading %s...", lib_path);

	game->update = NULL;

	if (old_lib && (dlclose(old_lib) != 0)) {
		ERROR("%s", dlerror());
		return NULL;
	}

	lib_handle = dlopen(lib_path, RTLD_LAZY | RTLD_LOCAL);
	if (!lib_handle) {
		ERROR("%s", dlerror());
		return NULL;
	}

	get_api = (get_game_api *)dlsym(lib_handle, "get_api");
	if (!get_api) {
		ERROR("%s", dlerror());
		if (dlclose(lib_handle) != 0) {
			ERROR("%s", dlerror());
		}
		return NULL;
	}

	if (!(engine = get_api(game))) {
		return lib_handle;
	}

	engine->vlog_output = vlog_output;
	engine->request_close = request_close;

	return lib_handle;
}
