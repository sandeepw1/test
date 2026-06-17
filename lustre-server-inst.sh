sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo setenforce 0
sudo sed -i 's/^SELINUX=Enforcing/SELINUX=disabled/' /etc/selinux/config
read -p "Enter The hostname: " hname
sudo hostnamectl set-hostname $hname
sudo yum install epel-release -y
sudo dnf config-manager --set-enabled crb
sudo scp admin@192.168.81.166:/etc/yum.repos.d/lustre-server.repo .
sudo cp lustre-server.repo /etc/yum.repos.d/
sudo yum clean all
sudo yum makecache
sudo dnf install -y  wget  vim  net-tools  lsof  e2fsprogs
sudo dnf install -y   kernel   kernel-core   kernel-modules  kernel-devel
wget https://downloads.whamcloud.com/public/lustre/lustre-2.17.0/el9.7/server/RPMS/x86_64/kernel-5.14.0-611.13.1_lustre.el9.x86_64.rpm
sudo yum localinstall kernel-5.14.0-611.13.1_lustre.el9.x86_64.rpm
sudo dnf install -y   lustre   kmod-lustre   kmod-lustre-osd-ldiskfs   lustre-osd-ldiskfs-mount   e2fsprogs
sudo grubby --set-default /boot/vmlinuz-5.14.0-611.13.1_lustre.el9.x86_64
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
sudo init 6
