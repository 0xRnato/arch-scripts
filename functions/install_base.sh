#!/bin/bash

function install_base() {
	echo_message header "Pre-installation"
	echo_message info "Set the keyboard layout"
	loadkeys br-abnt2
	echo_message info "Verify the boot mode"
	if [ ! -d /sys/firmware/efi/efivars ]; then
		echo_message error "Please, boot with UEFI mode."
		exit 99
	fi
	echo_message info "Verify internet connection"
	ping -c 3 archlinux.org
	echo_message info "Update the system clock"
	timedatectl set-ntp true
	echo_message info "Partition the disks"
	sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' <<EOF | fdisk /dev/sda
  g
  n
  1

  +300M
  t
  1
  n
  2

  +550M
  n
  3


  t
  3
  31
  w
EOF
	echo_message info "Format the partitions"
	mkfs.fat -F32 /dev/sda1
	mkfs.ext2 /dev/sda2
	cryptosetup luksFormat /dev/sda3
	cryptosetup open --type luks /dev/sda3 lvm
	pvcreate --dataalignment 1m /dev/mapper/lvm
	vgcreate volgroup0 /dev/mapper/lvm
	vgcreate volgroup0 /dev/mapper/lvm
	lvcreate -L 150GB volgroup0 -n lv_root
	lvcreate -L 100%FREE volgroup0 -n lv_home
	modprobe dm_mod
	vgscan
	vgchange -ay
	mkfs.ext4 /dev/volgroup0/lv_root
	mkfs.ext4 /dev/volgroup0/lv_home
	echo_message info "Mount the file systems"
	mount /dev/volgroup0/lv_root /mnt
	mkdir /mnt/boot
	mkdir /mnt/home
	mount /dev/sda2 /mnt/boot
	mount /dev/volgroup0/lv_home /mnt/home
	echo_message header "Installation"
	echo_message info "Select the mirrors"
	pacman -Syy reflector
	reflector --latest 1000 --threads 4 --protocol https --protocol http --sort rate --save /etc/pacman.d/mirrorlist
	echo_message info "Install the base packages"
	pacstrap /mnt base base-devel
	echo_message header "Configure the system"
	echo_message info "Fstab"
	genfstab -U -p /mnt >>/mnt/etc/fstab
	echo_message info "Chroot"
	arch-chroot /mnt
	echo_message info "Time zone"
	ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
	hwclock --systohc
	echo_message info "Localization"
	echo -e "pt_BR.UTF-8 UTF-8\nen_US.UTF-8 UTF-8" >>/etc/locale.gen
	locale-gen
	echo -e "LANG=en_US.UTF-8" >/etc/locale.conf
	echo -e "KEYMAP=br-abnt2" >/etc/vconsole.conf
	echo_message info "Network configuration"
	echo -e "Arch" >>/etc/hostname
	echo -e "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\tArch.localdomain\tArch" >/etc/hosts
	echo_message info "Root password"
	passwd
	echo_message info "Create new user"
	useradd -m -g users -s /bin/bash rnato
	passwd rnato
	echo -e "rnato ALL=(ALL) ALL" >>/etc/sudoers
	echo_message info "Install some packages"
	pacman -Syyuu yaourt iw wpa_supplicant dialog bash-completion
	yaourt -Syyuua
	systemctl enable dhcpcd.service
	echo_message info "Boot loader"
	pacman -S intel-ucode grub os-prober efibootmgr dosfstools mtools
  sed -i 's/HOOKS=(base udev autodetect modconf block filesystems keyboard fsck)/HOOKS=(base udev autodetect modconf block encrypt lvm2 filesystems keyboard fsck)/g'
  GRUB_CMDLINE_LINUX_DEFAULT="cryptdevice=/dev/sda3:volgroup0 quiet"
  mkdir /boot/EFI
  mount /dev/sda1 /boot/EFI
  grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=grub_uefi --recheck
  cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
  grub-mkconfig -o /boot/grub/grub.cfg
  echo_message info "Swap file"
  fallocate -l 24G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  echo '/swapfile none swap sw 0 0 ' | tee -a /etc/fstab
  echo_message info "Initramfs"
	mkinitcpio -p linux
	echo_message success "Installation finished"
	echo_message info "Rebooting the machine..."
	exit
	umount -R /mnt
	reboot
}
