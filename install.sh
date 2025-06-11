#!/bin/bash


echo -e "\nA little reminder... If you have any trouble running this script, please, ensoure that you aren't running this as sudo, and that you own your /home directory, you can do that by typing (sudo chown -R "Your User" /home)" && sleep 1

read -p "Now that I said that.. Do you want to start? (Y/n): " scriptrun

if [[ "scriptrun" == "y" || "scriptrun" == "Y" ]]; then

	pacman -Sy --needed git base-devel kitty

	git clone https://aur.archlinux.org/paru-bin.git
	cd paru-bin
	echo "Estamos en la carpeta de paru" && sleep 5
	makepkg -si
	cd ..

	read -p "Do you want to apply a basic pacman config? (Y/N)" respuesta

	if [[ "$respuesta" == "y" || "$respuesta" == "Y" ]]; then
		echo "Nice!"
		cat pacman.conf | sudo tee /etc/pacman.conf #> /dev/null
		paru --noconfirm -Syu --needed base-devel kitty floorp-bin hyprland hyprpaper rofi dolphin waybar fastfetch github-cli alsa-lib alsa-utils pipewire pipewire-pulse pipewire-alsa pipewire-jack pipewire-media-session steam discord prismlauncher blender ly
	elif [[ "$respuesta" == "n" || "$respuesta" == "N" ]]; then
		echo "Ok, let's do the rest of this..."
		paru --noconfirm -Syu --needed base-devel kitty floorp-bin hyprpaper rofi dolphin waybar fastfetch github-cli libreoffice alsa-lib alsa-utils pipewire pipewire-pulse pipewire-alsa pipewire-jack pipewire-media-session ly

	fi

	sudo systemctl enable ly

#else
#	echo "Then, see you later!"

fi
