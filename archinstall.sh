#!/bin/bash

	echo "Estamos en el script correcto"

pacstrap /mnt base linux linux-firmware sof-firmware nano neovim sudo base-devel grub efibootmgr networkmanager

genfstab /mnt > /mnt/etc/fstab

arch/chroot /mnt

ln -sf /usr/share/zoneinfo/America/Argentina/Buenos_Aires
hwclock --systohc

sed -i 's/^#es_AR.UTF-8 UTF-8/es_AR.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=es_AR.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf

read -p "Defina el nombre del equipo (hostname): " hstnm
echo "$hstnm" > /etc/hostname

echo -e "Defina una password para el usuario root\n"
passwd

read -p "Agregue el nombre de su usuario (SIN MAYUSCULAS)" usuario
useradd -m -G wheel -s /bin/bash $usuario

echo "Defina una password para su usuario"
passwd $usuario

sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

systemctl enable NetworkManager

read -p "La unidad donde instalo su equipo es? /dev/" disco

grub-install /dev/$disco
grub-mkconfig -o /boot/grub/grub.cfg

exit

umount -a

echo "El sistema se reiniciara en 3..." && sleep 1
echo "El sistema se reiniciara en 2..." && sleep 1
echo "El sistema se reiniciara en 1.." && sleep 1
reboot now
