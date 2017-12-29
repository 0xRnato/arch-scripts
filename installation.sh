# PART 1 (FIRST BOOT)
# Atl+arrow to switch on the terminals tty1...

ls /usr/share/kbd/keymaps/**/*.map.gz # list the aviliable keyboards layouts
loadkeys br-abnt2 # set the brazilian keyboard
ls /sys/firmware/efi/efivars # verify the UEFI bootmode
ping -c 3 archlinux.org # check internet connection dhcpcd or wifi-menu to connect
timedatectl status # check clock status
timedatectl set-ntp true # update clock service


# Create partitions
fdisk -l # or lsblk
cfdisk /dev/sda # select 'dos' label type
# /dev/sda1 for /boot - Type: EFI System Partition - Bootable flag: TRUE - Suggested size: 260–512 MiB
# /dev/sda2 for [SWAP] - Type: Linux swap - Bootable flag: FALSE - Suggested size: More than 512 MiB or 1.5 * RAM
# /dev/sda3 for / - Type: Linux - Bootable flag: FALSE - Suggested size: Remainder of the device

# Format partitions
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda3
mkswap /dev/sda2
swapon /dev/sda2

# Mount partitions
mount /dev/sda3 /mnt
mkdir /mnt/boot /mnt/var /mnt/home
mount /dev/sda1 /mnt/boot

# Update live system and select the best mirror
pacman -Syu
pacman -S reflector
reflector --verbose -l 5 --sort rate --save /etc/pacman.d/mirrorlist

# Install the base packages
pacstrap -i /mnt base base-devel

# Fstab
genfstab -U -p /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

# Chroot
arch-chroot /mnt

# Time zone
ls /usr/share/zoneinfo
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc # or with --utc

# Locale
nano /etc/locale.gen # uncomment pt_BR.UTF-8 UTF8
locale-gen
echo LANG=PTBR.UTF-8 > /etc/locale.conf
export LANG=PTBR.UTF-8

# keyboard layout
echo KEYMAP=br-abnt2 > /etc/vconsole.conf
export KEYMAP=br-abnt2

# Hostname
nano /etc/hostname # myhostname
nano /etc/hosts
# add the fallowing lines and save it
# 127.0.0.1	localhost.localdomain	localhost
# ::1		localhost.localdomain	localhost
# 127.0.1.1	myhostname.localdomain	myhostname

# Save the mirror list
nano /etc/pacman.conf
# Uncomment the line: [multilib] and Include = /etc/pacman.d/mirrorlist
#and add this lines
# [archlinuxfr]
# SigLevel = Never
# Server = http://repo.archlinux.fr/$arch

# Update system and install network packages
sudo pacman -Syu
sudo pacman -Sy
sudo pacman -S yaourt
yaourt -Syua –devel
yaourt -Syyuua
yaourt -Syu –devel –aur
sudo pacman -S iw wpa_supplicant dialog bash-completion

# Root password
passwd

# Create new userç
useradd -m -g users -G games,http,log,rfkill,sys,wheel,dbus,kmem,locate,lp,mail,smmsp,tty,utmp,audio,disk,floppy,input,kvm,optical,scanner,storage,video -s /bin/bash rnato
passwd rnato
EDITOR=nano visudo # write tha fallowing line
# rnato ALL=(ALL) NOPASSWD: ALL

# Enable network connection after rebooting
systemctl enable dhcpcd.service

# Install grup and configure it
mkinitcpio -p linux
pacman -S intel-ucode grub os-prober
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

exit
umount -R /mnt
reboot




PART 2

# dhcpcd or wifi-menu to enable interet connection
## wlp3s0
ping -c 3 archlinux.org

# Crate user dirs
ls /home/seu_usuario
sudo pacman -S xdg-user-dirs
xdg-user-dirs-update

# Some diveces drivers
pacman -S xorg-server xorg-apps xf86-input-mouse xf86-input-keyboard xf86-input-synaptics xorg-xinit xorg-twm xterm xorg-xclock

# Detect your card graphics
lspci | grep -e VGA -e 3D

# Install graphics driver
# FOR VIRTUALBOX ONLY
pacman -S xf86-video-fbdev virtualbox-guest-utils virtualbox-guest-modules-arch
# Insert guest addions CD on virtualboxand run:
mount /dev/sr0 /mnt
./mnt/VBoxLinuxAdditions.run

# REAL MACHINE
# Generic AMD
pacman -S xf86-video-amdgpu
# Generic Intel
pacman -S xf86-video-intel
# Generic Nvidia
pacman -S xf86-video-nouveau
# AUR AMD
yaourt -S catalyst –noconfirm

# Test the X Server
startx
#ctrl+d to exit

# GNOME Desktop Environment
sudo pacman -S gnome gnome-extra
sudo systemctl enable gdm.service

# Deepin Desktop Environment
sudo pacman -S deepin deepin-extra lightdm
sudo nano /etc/lightdm/lightdm.conf # uncomment and edit this line after [Seat:*] - greeter-session=lightdm-deepin-greeter
sudo systemctl enable lightdm.service

# Network
sudo pacman -S networkmanager
sudo systemctl enable NetworkManager.service

# Install some drivers
sudo pacman -S acpid ntp dbus avahi cups cronie
systemctl enable acpid.service
systemctl enable ntpd.service
systemctl enable avahi-daemon.service
systemctl enable org.cups.cupsd.service

reboot

pacman -Qdt

# Comandos Básicos do Pacman e Yaourt
sudo pacman -Sy # sincroniza os repositórios.
sudo pacman -Su # procura por atualização.
sudo pacman -Syu # sincroniza os repositórios/procura por atualização.
sudo pacman -Syy # sincroniza os repositórios do Manjaro Linux.
sudo pacman -Syyu # sincronização total/procura por atualização.
sudo pacman -S pacote # instala um pacote.
sudo pacman -R pacote # remove um pacote.
sudo pacman -Rs pacote # remove o pacote junto com as dependências não usadas por outros pacotes.
sudo pacman -Rsn pacote # remove o pacote junto com as dependências não usadas por outros pacotes e junto com os arquivos de configuração.
sudo pacman -Ss pacote # procura por um pacote.
sudo pacman -Sw pacote # apenas baixa o pacote e não o instala.
sudo pacman -Si pacote # mostra informações de um pacote não instalado.
sudo pacman -Qi pacote # mostra informações do pacote já instalado.
sudo pacman -Se pacote # instala apenas as dependências.
sudo pacman -Ql pacote # mostra todos os arquivos pertencentes ao pacote.
sudo pacman -Qu # mostra os pacotes que serão atualizados.
sudo pacman -Q # lista todos os pacotes instalados.
sudo pacman -Qo arquivo # mostra a qual pacote aquele arquivo pertence.
sudo pacman -Qdt # lista pacotes desnecessários, sem dependências
sudo pacman -Rns $(pacman -Qqdt) # apaga pacotes desnecessários, sem dependências
sudo pacman -A pacote.pkg.tar.gz # instala um pacote local.
sudo pacman -Sc # deleta do cache todos os pacotes antigos.
sudo pacman -Scc # limpa o cache, removendo todos os pacotes existentes no /var/cache/pacman/pkg/.
sudo pacman-optimize # otimiza a base de dados do pacman.
sudo pacman -Sdd # instala ignorando as dependências.
sudo pacman -Rdd # elimina um pacote ignorando as dependências.
sudo pacman-mirrors.conf # para gerenciar pacman.cof
sudo pacman-mirrors -g # para gerar um novo mirrorlist
sudo pacman -U home/user/arquivo.tar.xz # instalar pacotes baixados no pc
sudo pacman -U http://www.site.com/arquivo.tar.xz # instalar pacotes baixados via download
sudo pacman -Qem # lista pacotes instalados do repo AUR
sudo pacman -Rscn # desinstala pacotes e suas dependencias e seus registros, tudo.
sudo pacman -S pacote –nonconfirm # Instala o pacote sem precisar confirmar com “yes/no ,S/N”…
sudo pacman -Syu –ignoregroup pacote1 , pacote2… # sincroniza os repositórios/procura por atualização e ignora os grupos dos pacotes solicitados

yaourt -Syua –devel # sincronizar a base de dados
yaourt -Syyuua # atualizar o repo AUR
yaourt -Ss nome # pesquisar no repo AUR
yaourt -S nome –noconfirm # instalar pacotes do repo AUR
yaourt -R nome # remover pacotes do repo AUR
yaourt -Rsn nome # remover pacotes + dependências do repo AUR
yaourt -Syu –devel –aur # sincronizar a base de dados e atualiza pacotes

https://wiki.archlinux.org/index.php/General_recommendations
https://wiki.archlinux.org/index.php/Core_utilities



personalizar o bash

$ vim .bashrc

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u\[\033[01;33m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;37m\]\w\[\033[01;32m\]\$\[\033[00m\] '
 
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'
alias grep='grep --color'
alias atualizar='yaourt -Syyuua'