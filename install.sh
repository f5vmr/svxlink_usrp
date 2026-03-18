#!/bin/bash
# Auto run audio_update.sh
export LANGUAGE=en_GB.UTF-8
GREEN="\033[1;32m"
NORMAL="\033[0;39m"
RED="\033[1;31m"
YELLOW="\033[1;33m"

CONF="/etc/svxlink/svxlink.conf"
OP="/etc/svxlink"
cd
apt-get update
apt-get install -y ca-certificates curl gnupg

apt update
apt upgrade -yq
VERSIONS="svxlink/src/versions"

	echo -e `date` " ${YELLOW}  *** commence build *** ${NORMAL}"

# Installing other packages
	echo -e `date` " ${YELLOW} Installing required software packages${NORMAL}"
	apt-get -yq install gcc g++ make cmake libgcrypt-dev libgsm1-dev libsigc++-2.0-dev tcl-dev libspeex-dev libasound2-dev libpopt-dev libssl-dev libopus-dev groff libcurl4-openssl-dev git mc libjsoncpp-dev apache2 apache2-utils php8.2 libapache2-mod-php8.2 -y
	echo         
	echo -e "${GREEN} Enter the node callsign: \n ${NORMAL}"
	echo
	read CallVar
	if [ “$CallVar” == “” ]; then
		echo “Sorry - Start this program again with a valid callsign”
		exit 1
	fi
	CALL=${CallVar^^}
	echo
	echo `date` Creating Node $CALL
# Creating Groups and Users
	echo -e `date` "${YELLOW} Creating Groups and Users ${NORMAL}"
	groupadd svxlink
	useradd -g svxlink -G tty,svxlink,audio,plugdev,dialout -c "SvxLink Master" --shell=/bin/false -m svxlink
 -d /etc/svxlink svxlink
	usermod -aG audio,nogroup,svxlink,plugdev svxlink
	
	sleep 40


# Downloading Source Code for SVXLink
	echo -e `date` "${YELLOW} downloading SVXLink source code … ${NORMAL}"
	cd
	git clone https://github.com/dl1hrc/svxlink.git
	cd svxlink
	git checkout svxlink-usrp
	cd src
	mkdir build
	cd build	
	# Compilation
	
	cmake -DUSE_QT=OFF -DCMAKE_INSTALL_PREFIX=/usr -DSYSCONF_INSTALL_DIR=/etc -DLOCAL_STATE_DIR=/var -DCMAKE_BUILD_TYPE=Release -DWITH_CONTRIB_USRP_LOGIC=ON -DWITH_SYSTEMD=ON ..
echo -e `date` "${YELLOW} Compiling ${NORMAL}"
	make
	#make doc
	echo `date` "${RED} Installing SVXlink ${NORMAL}"
	make install
	ldconfig
# Installing United Kingdom Sound files
	cd /usr/share/svxlink/sounds
	git clone https://github.com/f5vmr/en_GB
 	
	
	cd ..	
	chmod 777 *
	echo `date` backing up configuration to : $CONF.bak
	cd $OP
	cp -p $CONF $CONF.bak
#
	cd 
	echo -e `date` "${RED} Downloading prepared configuration files from G4NAB …${NORMAL}"
	mkdir scripts
	cp -r svxlink_usrp/svxlink.conf $OP
	
	cp -r svxlink_usrp/node_info.json $OP/node_info.json
	cp -r svxlink_usrp/resetlog.sh scripts/resetlog.sh
	(crontab -l 2>/dev/null; echo "59 23 * * * scripts/resetlog.sh ") | crontab -
#
	echo `date` Setting Callsign to $CALL
	sed -i "s/MYCALL/$CALL/g" $CONF
	sed -i "s/MYCALL/$CALL/g" $OP/node_info.json
#
	SERVICE_FILE="/usr/lib/systemd/system/svxlink.service"

# Remove the deprecated lines (exact match)
	sed -i '\|^Requires=svxlink_gpio_setup\.service$|d' "$SERVICE_FILE"
	sed -i '\|^After=svxlink_gpio_setup\.service$|d' "$SERVICE_FILE"

# Reload systemd and enable + start service
	systemctl daemon-reload
	systemctl enable --now svxlink


	echo -e `date` "${RED}Installation of SVXLink is complete\n${NORMAL}"
	echo -e `date` "${GREEN} Now for DVSwitch\n\n\n${NORMAL}"
	echo
	sleep 10
	cd 
	wget http://dvswitch.org/bookworm
	chmod +x bookworm
	./bookworm
	apt update -y && apt upgrade
	apt install dvswitch-server -y
	reboot


	
 
