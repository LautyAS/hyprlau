sudo pacman -S --needed git base-devel kitty

mkdir hyprlau

cd hyprlau/

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

echo 'configura pacman porfa'

nvim /etc/pacman.conf

paru --noconfirm -Syu --needed floorp-bin hyprland hyprpaper rofi dolphin waybar fastfetch github-cli alsa-lib alsa-jack alsa-utils pipewire pipewire-pulse pipewire-alsa pipewire-jack pipewire-media-session steam discord prism-launcher blender


echo 'Bueno, un pequeño comentario de lo que instalamos por si no te funciona la memoria, el navegador floorp, herramientas de ofimatica, se supone que todo lo que necesitas de audio, blender, fastfetch por la facha y ahora necesito un soft para hacer los pcbs, prontos a incorporar mas cositas utiles :D'


