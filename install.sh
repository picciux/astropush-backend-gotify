#! /bin/bash

##############################################################
# Astroberry-Push Gotify backend install script              #
##############################################################

PREFIX=
UNINSTALL=no

print_usage() {
    echo " USAGE: $0 [options]"
    echo "   OPTIONS"
    echo "    -p, --prefix <prefix>        prepend <prefix> to file installation paths"
    echo "    -u, --uninstall              uninstall previously installed files"
    echo "    -h, --help                   prints this help"
    echo
    exit 0
}

ARG=
OPTS=$( getopt -q -u -l prefix:,uninstall,help p:uh $* )
if [ $? != 0 ]; then
    echo "ERROR: invalid options"
    print_usage
    exit 1
fi

for o in $OPTS; do
    case $ARG in
        prefix)
            ARG=
            if [ "${o:0:2}" = "'-" ]; then
                echo "ERROR: Missing argument for -p|--prefix option" 1>&2
                echo
                exit 1
            fi
            PREFIX=$o
            continue
            ;;
    esac
    
    case $o in            
        --uninstall|-u)
            UNINSTALL=yes
            ;;

        --prefix|-p)
            ARG=prefix
            ;;
        --help|-h)
            print_usage
            ;;
    esac
done


MYDIR=$( dirname $0 )
MYDIR=$( realpath "$MYDIR" )

BACKENDS_DIR=$PREFIX/usr/share/astroberry-push/backends
CFG_DIR=$PREFIX/etc/astroberry-push

if [ ! -d "$CFG_DIR" ]; then
    echo "Error: config directory missing. Is astroberry-push frontend installed?" 1>&2
    exit 1
fi

if [ ! -d "$BACKENDS_DIR" ]; then
    echo "Error: backends directory missing. Is astroberry-push frontend installed?" 1>&2
    exit 1
fi

if [ "$1" = "uninstall" ]; then
    echo "### Uninstalling astroberry-push gotify backend..."
    sudo rm -R "$BACKENDS_DIR/gotify"
    if [ -f "$CFG_DIR/backend.gotify.conf" ]; then
        sudo rm "$CFG_DIR/backend.gotify.conf"
    fi
    echo "### Done!"
    exit 0
fi

echo "### Installing astroberry-push gotify backend..."
sudo mkdir -p "$BACKENDS_DIR/gotify"
sudo cp -r $MYDIR/backend/* "$BACKENDS_DIR/gotify/"

sudo $BACKENDS_DIR/gotify/gotify-init $PREFIX

echo "### Log backend installed!"
echo "### Don't forget to enable it editing /etc/astroberry-push/push.conf"
echo


