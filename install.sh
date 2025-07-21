#!/bin/bash

#Update system
sudo pacman -Syu --noconfirm

#Install base
sudo pacman -S --noconfirm base-devel

#Install essentials
sudo pacman -S --noconfirm e2fsprogs dosfstools man-db man-pages texinfo networkmanager timeshift jq curl wget make clang base-devel imagemagick

#Enable network service
sudo systemctl enable NetworkManager

##Configure daily backup service
#Add to filter list boot as part of backups
if ! grep -Fxq "+ /boot" /etc/timeshift/filters.list 2> /dev/null; then
    echo -e "+ /boot" | sudo tee -a /etc/timeshift/filters.list > /dev/null
fi

#Duplicate snapshots scrip and give permissions 
if [ ! -e /usr/local/bin/timeshift-daily-if-needed.sh ]; then
    sudo cp ./timeshift-daily-if-needed.sh /usr/local/bin/timeshift-daily-if-needed.sh
    sudo chmod +x /usr/local/bin/timeshift-daily-if-needed.sh
fi

#Duplicate service and enable
if [ ! -e /etc/systemd/system/timeshift-autobackup.service ]; then
    sudo cp ./timeshift-autobackup.service /etc/systemd/system/timeshift-autobackup.service
fi

sudo systemctl daemon-reload
sudo systemctl enable timeshift-autobackup.service

#Duplicate snapshots configuration
if [ ! -e /etc/timeshift.json ]; then
    sudo cp .timeshift.json /etc/timeshift.json
fi