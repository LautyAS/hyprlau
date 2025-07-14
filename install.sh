#!/bin/bash

#mis fuentes favoritas son: ttf-firacode-nerd ttf-noto-nerd y ttf-sourcedodepro-nerd

paquetes_of=(base-devel kitty ly hyprland hyprpaper fuzzel waybar fastfetch github-cli alsa-lib alsa-utils pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber steam discord prismlauncher ly ttf-nerd-fonts-symbols ttf-noto-nerd ttf-firacode-nerd ttf-sourcecodepro-nerd noto-fonts spotify-launcher pavucontrol)
paquetes_aur=(floorp-bin)
paquetes=("${paquetes_of[@]}" "${paquetes_aur[@]}")

echo -e "\nA little reminder... If you have any trouble running this script, please, ensoure that you aren't running this as sudo, and that you own your /home directory, you can do that by typing (sudo chown -R "Your User" /home)\n" && sleep 1

read -p "Now that I said that.. Do you want to start? (Y/n): " strun

if [[ "$strun" == "y" || "$strun" == "Y" ]]; then

	sudo pacman -Syyu --needed --noconfirm git base-devel
	
	echo "Doing a backup of pacman.conf on pacman.conf.bak"

	CONFPM="/etc/pacman.conf"
	sudo cp "$CONFPM" "${CONFPM}.bak"										#Making a backup of the actual pacman.conf
	
	echo "Applying basic pacman tweaks..."

	grep -q "^ILoveCandy" "$CONFPM" || sudo sed -i '/^#Color/i ILoveCandy' "$CONFPM"				#Adding ILoveCandy above Color
	sudo sed -i 's/^#/Color/Color' "$CONFPM"									#Discomenting Color
	sudo sed -i 's/^#\?\s*ParallelDownloads *= *.*/ParallelDownloads = 10/' "$CONFPM"				#Changing quantity of parallel downloads
	sudo sed -i '/^\s*#\[multilib\]/s/^#//' "$CONFPM"								#Discomenting multilib
	sudo sed -i '/^\[multilib\]/,/^$/s/^\(\s*\)#\s*\(Include = \/etc\/pacman.d\/mirrorlist\)/\1\2/' "$CONFPM"	#Discomenting the mirrorlist for multilib
	
	echo "Installing paru to manage aur packages..."

	git clone https://aur.archlinux.org/paru-bin.git
	cd paru-bin
	makepkg -si
	cd ..
	rm -rf paru-bin

	paru -Syyu --noconfirm --needed "${paquetes[@]}"
	
	echo "Doing some aestethic tweaking"

	mkdir -p ~/.config/hypr
	systemctl --user mask at-spi-dbus-bus.service
	cp ~/hyprlau/configs/fuzzel.ini ~/.config/fuzzel.ini
	cp ~/hyprlau/configs/hyprland.conf ~/.config/hypr/hyprland.conf
	sudo cp ~/hyprlau/configs/waybarcfg.jsonc /etc/xdg/waybar/config.jsonc 
	cp ~/hyprlau/configs/hyprpaper.conf ~/.config/hypr/hyprpaper.conf
	cp -r ~/hyprlau/rice ~/rice
	sudo systemctl enable ly

fi
