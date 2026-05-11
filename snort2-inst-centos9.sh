echo "Installing Snort on this system"
echo "###############################"
echo "Installing updates and pre-requisites"
echo "##############################"
sleep 5
sudo dnf update -y
sudo dnf groupinstall "Development Tools" -y
sudo dnf install -y epel-release
sudo dnf install -y  pcre-devel libdnet-devel 
sudo dnf --enablerepo=crb install libpcap-devel libnghttp2-devel libtirpc-devel  luajit luajit-devel -y
echo "##############################"
echo "Updates and pre-requisites installed successfully"
echo "##############################"
echo "Installing DAQ Library"
sleep 3
mkdir ~/snort_src && cd ~/snort_src
wget https://www.snort.org/downloads/snort/daq-2.0.7.tar.gz
tar -xvzf daq-2.0.7.tar.gz
cd daq-2.0.7
./configure && make && sudo make install
echo "################################"
echo "DAQ library installed successfully"
echo "################################"
echo "Installing Snort 2.9"
sleep 3
cd ~/snort_src
wget https://www.snort.org/downloads/snort/snort-2.9.20.tar.gz
tar -xvzf snort-2.9.20.tar.gz
cd snort-2.9.20
./configure --enable-sourcefire && make && sudo make install
echo "###############################"
echo "Snort 2.9 installed successfully"
echo "###############################"
echo "Configuring snort"
sleep 3
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
sudo cp *.dtd /etc/snort
sudo touch /etc/snort/rules/white_list.rules
sudo touch /etc/snort/rules/black_list.rules
sudo touch /etc/snort/rules/local.rules
echo "Please Enter your network address: "
read net
sudo sed -i 's/^ipvar HOME_NET any/ipvar HOME_NET $net\/24/' /etc/snort/snort.conf
sudo sed -i 's/^ipvar EXTERNAL_NET any/ipvar EXTERNAL_NET !$HOME_NET/' /etc/snort/snort.conf
sudo sed -i 's|var RULE_PATH.*|var RULE_PATH /etc/snort/rules|' /etc/snort/snort.conf
sudo sed -i 's|var SO_RULE_PATH.*|var SO_RULE_PATH /etc/snort/so_rules|' /etc/snort/snort.conf
sudo sed -i 's|var PREPROC_RULE_PATH.*|var PREPROC_RULE_PATH /etc/snort/preproc_rules|' /etc/snort/snort.conf
sudo sed -i 's|var WHITE_LIST_PATH.*|var WHITE_LIST_PATH /etc/snort/rules|' /etc/snort/snort.conf
sudo sed -i 's|var BLACK_LIST_PATH.*|var BLACK_LIST_PATH /etc/snort/rules|' /etc/snort/snort.conf
sudo sed -i '548,651s/^/#/' /etc/snort/snort.conf 
sudo snort -T -c /etc/snort/snort.conf &> /dev/null
if [ $? = 0 ]
then
echo "Snort Installed and Configured Successfully"
else 
echo "Please Check error at the end"
sudo snort -T -c /etc/snort/snort.conf 
fi






