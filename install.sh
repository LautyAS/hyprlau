#!/bin/bash

#mis fuentes favoritas son: ttf-firacode-nerd ttf-noto-nerd y ttf-sourcedodepro-nerd

echo -e "\nA little reminder... If you have any trouble running this script, please, ensoure that you aren't running this as sudo, and that you own your /home directory, you can do that by typing (sudo chown -R "Your User" /home)\n" && sleep 1

read -p "Now that I said that.. Do you want to start? (Y/n): " strun

if [[ "$strun" == "y" || "$strun" == "Y" ]]; then

	sudo pacman -Sy --needed --noconfirm git base-devel kitty
	git clone https://aur.archlinux.org/paru-bin.git
	cd paru-bin
	echo "Estamos en la carpeta de paru" && sleep 5
	makepkg -si
	cd ..
	rm -rf paru-bin

	read -p "Do you want to apply a basic pacman config? (Y/N)" respuesta
	if [[ "$respuesta" == "y" || "$respuesta" == "Y" ]]; then
		echo "Nice!"
		cat ~/hyprlau/configs/pacman.conf | sudo tee /etc/pacman.conf
		paru -Sy --noconfirm --needed base-devel kitty floorp-bin hyprland hyprpaper fuzzel dolphin waybar fastfetch github-cli alsa-lib alsa-utils pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber steam discord prismlauncher ly ttf-nerd-fonts-symbols ttf-noto-nerd ttf-sourcecodepro-nerd ttf-firacode-nerd noto-fonts spotify-launcher pavucontrol
	elif [[ "$respuesta" == "n" || "$respuesta" == "N" ]]; then
		echo "Ok, let's do the rest of this..."
		paru -Sy --noconfirm --needed base-devel kitty floorp-bin hyprpaper fuzzel dolphin waybar fastfetch github-cli libreoffice alsa-lib alsa-utils pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber ly ttf-nerd-fonts-symbols ttf-noto-nerd ttf-firacode-nerd ttf-sourcedodepro-nerd noto-fonts spotify-launcher pavucontrol
	fi
	
	cat ~/hyprlau/configs/fuzzel.ini | tee ~/.config/fuzzel.ini
	cat ~/hyprlau/configs/hyprland.conf | tee ~/.config/hypr/hyprland.conf
	cat ~/hyprlau/configs/waybarcfg.jsonc | sudo tee /etc/xdg/waybar/config.jsonc 
	sudo systemctl enable ly
fi
