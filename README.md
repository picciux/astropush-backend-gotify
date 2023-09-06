
# Gotify backend for AstroPush.

### What's AstroPush?
[AstroPush](https://github.com/picciux/astropush.git) is a shell script based notify abstraction layer, targeted mainly at KStars/Ekos astrophotography systems on linux.

### How to use.
This is the AstroPush backend to route notifications through stand-alone [Gotify](https://gotify.net) server. To use it, you need a running Gotify server running somewhere (localhost, your LAN, etc.); you can check `gotify_support_files` folder if you need to setup Gotify.

### Installation
1. Run `install.sh` script in this directory
2. The script will ask if you have a running Gotify service reachable somewhere. If that's the case, answer *yes* and continue. Otherwise, answer *no*. You can resume the installation later running `sudo /usr/share/astropush/backends/gotify/gotify-init`	
3. If you answered *yes*, the script will ask for your running Gotify service API URL address: if you have installed the gotify support files from `gotify_support_files` folder, you need to enter: `http://localhost:8627` otherwise, you have to provide it yourself.
4. Edit AstroPush main config `/etc/astropush/push.conf` (you need sudo) and enable this backend following comments inside the file itself.



