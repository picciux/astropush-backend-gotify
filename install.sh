#! /bin/bash

##############################################################
# AstroPush Gotify backend install script              #
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

BACKENDS_DIR=$PREFIX/usr/share/astropush/backends
CFG_DIR=$PREFIX/etc/astropush
DOC_DIR=$PREFIX/usr/share/doc/astropush

if [ ! -d "$CFG_DIR" ]; then
    echo "Error: config directory missing. Is astropush frontend installed?" 1>&2
    exit 1
fi

if [ ! -d "$BACKENDS_DIR" ]; then
    echo "Error: backends directory missing. Is astropush frontend installed?" 1>&2
    exit 1
fi

if [ "$UNINSTALL" = "yes" ]; then
    echo "### Uninstalling astropush gotify backend..."
    rm -R "$BACKENDS_DIR/gotify"
    if [ -f "$CFG_DIR/backend.gotify.conf" ]; then
        rm "$CFG_DIR/backend.gotify.conf"
    fi
    rm "$DOC_DIR/README.backend.gotify.md"
    rm "$DOC_DIR/LICENSE.backend.gotify"
    echo "### Done!"
    exit 0
fi

echo "### Installing astropush gotify backend..."
install -d "$BACKENDS_DIR/gotify/app-icons"
for ic in $( ls $MYDIR/backend/app-icons/*.png ); do
	install -m 644 "$ic" $BACKENDS_DIR/gotify/app-icons/
done
install -m 644 "$MYDIR/backend/backend.gotify.conf.sample" $BACKENDS_DIR/gotify/
install -m 644 "$MYDIR/backend/backend.sh" "$MYDIR/backend/gotify-init" $BACKENDS_DIR/gotify/
install -m 644 "$MYDIR/backend/backend.gotify.conf.sample" $CFG_DIR/backend.gotify.conf
install -m 644 "$MYDIR/README.md" "$DOC_DIR/README.backend.gotify.md"
install -m 644 "$MYDIR/LICENSE" "$DOC_DIR/LICENSE.backend.gotify"

echo "### Gotify backend installed!"
echo "### Next steps, check "
echo "###     $CFG_DIR/push.conf"
echo "###     $CFG_DIR/backend.gotify.conf"
echo "### to enable and configure it system-wide."
echo "### Check documentation for details."
echo

