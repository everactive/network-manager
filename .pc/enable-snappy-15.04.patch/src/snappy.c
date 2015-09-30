/* NetworkManager -- Network link manager
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 * Copyright (C) 2015 Canonical Ltd.
 */

#include <stdlib.h>

const char* get_snap_app_data_path()
{
	static char *path = NULL;

	if (!path)
		path = getenv("SNAP_APP_DATA_PATH");

	return path;
}

const char* get_snap_app_path()
{
	static char *path = NULL;

	if (!path)
		path = getenv("SNAP_APP_PATH");

	return path;
}
