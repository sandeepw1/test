echo "Installing Snort on this system"
echo "###############################"
echo "Installing updates and pre-requisites"
echo "##############################"
pause 5
sudo dnf update -y
sudo dnf groupinstall "Development Tools" -y
sudo dnf install -y epel-release
sudo dnf install -y  pcre-devel libdnet-devel 
sudo dnf --enablerepo=crb install libpcap-devel libnghttp2-devel libtirpc-devel  luajit luajit-devel -y
echo "##############################"
echo "Updates and pre-requisites installed successfully"
echo "##############################"
echo "Installing DAQ Library"
pause 3
mkdir ~/snort_src && cd ~/snort_src
wget https://www.snort.org/downloads/snort/daq-2.0.7.tar.gz
tar -xvzf daq-2.0.7.tar.gz
cd daq-2.0.7
./configure && make && sudo make install
echo "################################"
echo "DAQ library installed successfully"
echo "################################"
echo "Installing Snort 2.9"
pause 3
cd ~/snort_src
wget https://www.snort.org/downloads/snort/snort-2.9.20.tar.gz
tar -xvzf snort-2.9.20.tar.gz
cd snort-2.9.20
./configure --enable-sourcefire && make && sudo make install
echo "###############################"
echo "Snort 2.9 installed successfully"
echo "###############################"
echo "Configuring snort"
pause 3
sudo ldconfig
sudo ln -s /usr/local/bin/snort /usr/sbin/snort
sudo groupadd snort && sudo useradd snort -s /sbin/nologin -g snort
sudo mkdir /etc/snort
sudo mkdir /etc/snort/rules
sudo mkdir /var/log/snort
sudo mkdir /usr/local/lib/snort_dynamicrules
sudo chmod -R 775 /etc/snort /var/log/snort /usr/local/lib/snort_dynamicrules
sudo chown -R snort:snort /etc/snort /var/log/snort /usr/local/lib/snort_dynamicrules
cd ~/snort_src/snort-2.9.20/etc
sudo cp *.conf* /etc/snort
sudo cp *.map /etc/snort
sudo cp *.dtd /etc/snortsudo touch /etc/snort/rules/white_list.rules
sudo touch /etc/snort/rules/black_list.rules
sudo touch /etc/snort/rules/local.rules




