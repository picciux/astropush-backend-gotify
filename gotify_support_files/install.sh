#! /bin/bash

PREFIX=
UNINSTALL=no

HERE=$( dirname $0 )

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

CFGDIR=$PREFIX/etc/gotify
VARDIR=$PREFIX/var/lib/gotify
DATADIR=$VARDIR/data
IMGDIR=$VARDIR/images
PLUGINSDIR=$VARDIR/plugins
SYSDDIR=$PREFIX/etc/systemd/system

#me="$USER"
me=nobody
mygrp=nogroup

echo -n "Preparing directories... "

sudo mkdir -p $CFGDIR
sudo mkdir -p $VARDIR
sudo mkdir -p $DATADIR $IMGDIR $PLUGINSDIR
sudo chown $me:$mygrp $VARDIR/*
sudo mkdir -p $SYSDDIR
echo "done."

echo -n "Preparing files... "
sudo cp $HERE/config.yml $CFGDIR/

cat << -EOF | sudo tee $SYSDDIR/gotify.service > /dev/null
#
# Gotify systemd unit
# ===================
#
[Unit]
Description=Gotify: a stand alone push notification service
Requires=network.target
After=network.target nss-lookup.target

[Service]
Type=exec
User=$me
ExecStart=/usr/bin/gotify
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target

-EOF

echo "done."

echo -n "Starting Gotify service... "
sudo systemctl daemon-reload
sudo systemctl --now enable gotify.service
echo "done."
echo
echo
