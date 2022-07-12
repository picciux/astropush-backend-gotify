#    Gotify backend for Astroberry-Push, a simple push notification layer for Astroberry.
#    Copyright (C) 2022  Matteo Piscitelli <matteo@matteopiscitelli.it>
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Gotify backend implementation

# default
host='localhost'
hostdesc=''

source "$CONFIG_DIR/backend.gotify.conf"

if [ "$host" != "localhost" ]; then hostdesc="@$( hostname )"; fi

push_gotify() {
  prio=5

  case "$1" in
	"astroberry")
	app_token="$astroberry"
	title="Astroberry$hostdesc"
	;;

	"alignment")
	app_token="$alignment"
	title="Alignment$hostdesc"
	;;

	"capture")
	app_token="$capture"
	title="Capture$hostdesc"
	;;

	"focus")
	app_token="$focus"
	title="Focus$hostdesc"
	;;

	"kstars")
	app_token="$kstars"
	title="KStars$hostdesc"
	;;

	"guide")
	app_token="$guide"
	title="Guide$hostdesc"
	;;

	"mount")
	app_token="$mount"
	title="Mount$hostdesc"
	;;

	"scheduler")
	app_token="$scheduler"
	title="Scheduler$hostdesc"
	;;

	*)
	app_token="$astroberry"
	title="Sconosciuto: $1$hostdesc"
	;;

  esac

  case $3 in
	#verbose
	1)
	prio=0
	;;

	#info
	2)
	prio=2
	;;

	#warn
	3)
	prio=5
	;;

	#error
	4)
	prio=10
	;;
  esac

  curl --silent "http://$host/gotify/message?token=$app_token" -F "title=$title" -F "message=$2" -F "priority=$prio" > /dev/null

}
