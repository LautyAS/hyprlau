#!/bin/bash

#mis fuentes favoritas son: ttf-firacode-nerd ttf-noto-nerd y ttf-sourcedodepro-nerd

paquetes_of=(base-devel kitty ly hyprland hyprpaper fuzzel waybar fastfetch github-cli alsa-lib alsa-utils pipewire pipewire-pulse pipewire-alsa pipewire-jack wireplumber steam discord prismlauncher ttf-nerd-fonts-symbols ttf-noto-nerd ttf-firacode-nerd ttf-sourcecodepro-nerd noto-fonts spotify-launcher pavucontrol lib32-pipewire)
paquetes_aur=(floorp-bin)
paquetes_gpu=(lib32-mesa mesa-utils vulkan-tools)
#paquetes=("${paquetes_of[@]}" "${paquetes_aur[@]}" "${paquetes_gpu[@]}")

echo -e "\nA little reminder... If you have any trouble running this script, please, ensure that you aren't running this as sudo, and that you own your /home directory, you can do that by typing (sudo chown -R \$(whoami) /home)\n" && sleep 1

read -p "Now that I said that.. Do you want to start? (y/N): " strun

if [[ "$strun" == "y" || "$strun" == "Y" ]]; then
	
	#Base preparation
	sudo pacman -Sy --needed --noconfirm git base-devel reflector
	sudo reflector --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist
	sudo pacman -Syy
	sudo pacman -Sy --noconfirm archlinux-keyring
	sudo pacman-key --init
	sudo pacman-key --populate archlinux
	sudo pacman-key --refresh-keys || echo "→ Some keys could not be refreshed (probably by timeout), but we will continue..."


	#pacman.conf backup
	echo "Doing a backup of pacman.conf on pacman.conf.bak"
	CONFPM="/etc/pacman.conf"
	sudo cp "$CONFPM" "${CONFPM}.bak"
	
	#configuración de pacman
	echo "Applying basic pacman.conf tweaks..."
	grep -q "^ILoveCandy" "$CONFPM" || sudo sed -i '/^#Color/i ILoveCandy' "$CONFPM"
	#sudo sed -i 's/^#/Color/Color' "$CONFPM"
	sudo sed -i 's/^#Color/Color/' "$CONFPM"
	sudo sed -i 's/^#\?\s*ParallelDownloads *= *.*/ParallelDownloads = 10/' "$CONFPM"
	sudo sed -i '/^\s*#\[multilib\]/s/^#//' "$CONFPM"
	sudo sed -i '/^\[multilib\]/,/^$/s/^\(\s*\)#\s*\(Include = \/etc\/pacman.d\/mirrorlist\)/\1\2/' "$CONFPM"
	
	#paru
	if ! command -v paru &> /dev/null; then
    		echo "Paru not found. Installing it to manage aur packages..."
		git clone https://aur.archlinux.org/paru-bin.git
		cd paru-bin
		makepkg -s --noconfirm
		paru_pkg=$(ls paru-bin-*.pkg.tar.zst | tail -n1)
		sudo pacman -U --noconfirm "$paru_pkg"
		cd ..
		rm -rf paru-bin
	fi

	#GPU thigies
	echo -e "\nSelect your GPU vendor:\n"
	echo "1) AMD"
	echo "2) Intel"
	echo "3) NVIDIA"
	echo "4) Skip (I will handle Vulkan manually) (This option generally installs amdvlk as default)"
	read -p "Choice: " gpu_choice

	case "$gpu_choice" in
  	1)
    		echo "→ AMD selected"
    		paquetes_gpu+=(vulkan-radeon lib32-vulkan-radeon)
		;;
  	2)
    		echo "→ Intel selected"
    		paquetes_gpu+=(vulkan-intel lib32-vulkan-intel intel-media-driver)
    		;;
  	3)
    		echo "→ NVIDIA selected"
    		paquetes_gpu+=(nvidia nvidia-utils lib32-nvidia-utils nvidia-settings)
    		;;
  	*)
    		echo "→ Skipping GPU-specific packages"
    		;;
	esac

	#Installation
	paquetes=("${paquetes_of[@]}" "${paquetes_aur[@]}" "${paquetes_gpu[@]}")
	paru -Syyu --noconfirm --needed "${paquetes[@]}"
	paru -Sc --noconfirm
	
	#Rice
	echo "Doing some RICING"
	mkdir -p ~/.config
	mkdir -p ~/.config/hypr
	sudo mkdir -p /etc/xdg/waybar
	cp ~/hyprlau/configs/fuzzel.ini ~/.config/fuzzel.ini
	cp ~/hyprlau/configs/hyprland.conf ~/.config/hypr/hyprland.conf
	sudo cp ~/hyprlau/configs/waybarcfg.jsonc /etc/xdg/waybar/config.jsonc 
	cp ~/hyprlau/configs/hyprpaper.conf ~/.config/hypr/hyprpaper.conf
	cp -r ~/hyprlau/rice ~/rice
	
	#Optimization
	sudo pacman -Rns --noconfirm $(paru -Qtdq)
	read -p "¿Do you want to disable (at-spi-dbus-bus) to save some resources? (It is an accesibility service, most people don't need it) (y/N): " a11y
	if [[ "$a11y" == "y" || "$a11y" == "Y" ]]; then
    		systemctl --user mask at-spi-dbus-bus.service
	fi

	#enabling ly
	sudo systemctl enable ly

	echo "Everything done. Just reboot and enjoy!"
fi
