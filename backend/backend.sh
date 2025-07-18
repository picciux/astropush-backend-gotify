#    Gotify backend for AstroPush, a simple push notification layer.
#    Copyright (C) 2022-2023  Matteo Piscitelli <matteo@matteopiscitelli.it>
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

BACKEND_VERSION="2.1.2"

push_gotify() {
  # default
  api='http://localhost:8627'
  hostdesc=''

  # Source system config
  [ -f "$CONFIG_DIR/backend.gotify.conf" ] && source "$CONFIG_DIR/backend.gotify.conf"

  # override with user config
  [ -f "$USER_CONFIG_BE_PREFIX.gotify.conf" ] && source "$USER_CONFIG_BE_PREFIX.gotify.conf"

  # Add host description if we're notifying through a remote server
  [[ "$api" =~ "localhost" ]] || hostdesc="@$( hostname )"

  prio=5

  case "$1" in
	"os")
	[ "$os" != "" ] && app_token="$os"
	title="OS$hostdesc"
	;;

	"alignment")
	[ "$alignment" != "" ] && app_token="$alignment"
	title="Alignment$hostdesc"
	;;

	"capture")
	[ "$capture" != "" ] && app_token="$capture"
	title="Capture$hostdesc"
	;;

	"focus")
	[ "$focus" != "" ] && app_token="$focus"
	title="Focus$hostdesc"
	;;

	"kstars")
	[ "$kstars" != "" ] && app_token="$kstars"
	title="KStars$hostdesc"
	;;

	"guide")
	[ "$guide" != "" ] && app_token="$guide"
	title="Guide$hostdesc"
	;;

	"mount")
	[ "$mount" != "" ] && app_token="$mount"
	title="Mount$hostdesc"
	;;

	"scheduler")
	[ "$scheduler" != "" ] && app_token="$scheduler"
	title="Scheduler$hostdesc"
	;;

	*)
	[ "$os" != "" ] && app_token="$os"
	title="Sconosciuto: $1$hostdesc"
	;;

  esac

  if [ "$app_token" = "" ]; then
	"No app token available"
	exit 1
  fi

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

  curl --silent "$api/message?token=$app_token" -F "title=$title" -F "message=$2" -F "priority=$prio" > /dev/null

}
