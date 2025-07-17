
# Gotify backend for AstroPush.

### What's AstroPush?
[AstroPush](https://github.com/picciux/astropush.git) is a shell script based notify abstraction layer, targeted mainly at KStars/Ekos astrophotography systems on linux.

### How to use.
This is the AstroPush backend to route notifications through stand-alone [Gotify](https://gotify.net) server. To use it, you need a running Gotify server running somewhere (localhost, your LAN, etc.); you can check `gotify_support_files` folder if you need to setup Gotify.

### Installation
1. Run `install.sh` script in this directory
2. As an admin you can edit AstroPush main config `/etc/astropush/push.conf`  and `/etc/astropush/backend.gotify.conf` to enable and configure this backend following comments inside the files itself.
3. Alternatively, every user can override the system configuration creating and editing `push.conf` and `astropush-backend.gotify.conf` inside `~/.config` folder, thus using their own key and token.

You're done! From a terminal, try: `> astropush os 'This is a test' info`. You should receive a notification on your Gotify connected device(s).
