sudo rm -rf /etc/pacman.d/.gnupg
sudo rm -rf /etc/pacman.d/gnupg
sudo rm -rf /root/.gnupg
sudo rm -rf /root/gnupg
sudo rm -rf ~/.gnupg

sudo pacman -Sc --noconfirm

gpg --full-generate-key
gpg --list-secret-keys --keyid-format LONG
gpg --armor --export KEYID
git config --global user.signingkey KEYID
gpg --output ~/Downloads/public.key --armor --export rnato.netoo@gmail.com
gpg --export-secret-keys --armor rnato.netoo@gmail.com > ~/Downloads/private.asc

sudo pacman-key --init
sudo pacman -Sy archlinux-keyring archlinuxcn-keyring archstrike-keyring gnome-keyring libgnome-keyring --noconfirm

# sudo dirmngr </dev/null --homedir ~/.gnupg
sudo pacman-key --recv-keys 9D5F1C051D146843CDA4858BDE64825E7CBC0D51
sudo pacman-key --finger 9D5F1C051D146843CDA4858BDE64825E7CBC0D51
sudo pacman-key --lsign-key 9D5F1C051D146843CDA4858BDE64825E7CBC0D51
sudo pacman-key --recv-keys 7943315502A936D7
sudo pacman-key --finger 7943315502A936D7
sudo pacman-key --lsign-key 7943315502A936D7
sudo pacman-key --recv-keys 7448C890582975CD
sudo pacman-key --finger 7448C890582975CD
sudo pacman-key --lsign-key 7448C890582975CD
sudo pacman-key --populate archlinux
sudo pacman-key --refresh-keys

# dirmngr.conf
keyserver hkp://pool.sks-keyservers.net
keyserver ldap://keyserver.pgp.com
keyserver hkp://jirk5u4osbsr34t5.onion
keyserver hkp://keys.gnupg.net

# dirmngr_ldapservers.conf



sudo nano /etc/pacman.conf

sudo chmod 700 -R ~/.gnupg
sudo chown rnato:users -R ~/.gnupg
sudo chmod 600 -R ~/.gnupg/*
