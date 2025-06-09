sudo su

pacman -S --needed git base-devel kitty

mkdir hyprlau

cd hyprlau/

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

cd ..

echo "Do you want to apply a basic pacman config? (Y/N)"

read -p "Do you want to apply a basic pacman config? (Y/N)" respuesta

if [[ "$respuesta" == "y" || "$respuesta" == "Y" ]]; then
	echo "Nice!"
	cat pacman.conf > /etc/pacman.conf
	paru --noconfirm -Syu --needed floorp-bin hyprland hyprpaper rofi dolphin waybar fastfetch github-cli libreoffice alsa-lib alsa-utils pipewire pipewire-pulse pipewire-alsa pipewire-jack pipewire-media-session steam discord prismlauncher blender
elif [[ "$respuesta" == "n" || "$respuesta" == "N" ]]
	echo "Ok, let's do the rest of this..."
	paru --noconfirm -Syu --needed floorp-bin hyprpaper rofi dolphin waybar fastfetch github-cli libreoffice alsa-lib alsa-utils pipewire pipewire-pulse pipewire-alsa pipewire-jack pipewire-media-session
else
	echo "Sorry?"
fi
