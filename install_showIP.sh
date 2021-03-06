#!/bin/sh
#!/bin/bash
#############################################################################
# Filename: install_showIP.sh
# Date Created: 03/15/19
# Author: Marco Tijbout
#
# Version 1.0
#
# Description:  Script to install the showIP service and required files to
#               show the IP address on the SenseHAT attached to the Raspberry Pi.
#
#############################################################################


LOGFILE="/tmp/install_showIP.log"
echo "This is the script: install_showIP.sh" >> $LOGFILE

USERID=$(logname)
echo "The original executer: $USERID" 2>&1 | tee -a $LOGFILE

SERVICE=showip.service
DIRECTORY=/opt/scripts

## Create the folder for the scripts
if [ ! -d "$DIRECTORY" ]; then
    # Control will enter here if DIRECTORY NOT exists.
    if [ $? -eq 0 ]; then
        echo "Directory $DIRECTORY does not exists." 2>&1 | tee -a $LOGFILE
        sudo mkdir -p $DIRECTORY
        if [ $? -eq 0 ]; then
            echo "Directory $DIRECTORY created." 2>&1 | tee -a $LOGFILE 
        else
        echo "Directory $DIRECTORY could not be created." 2>&1 | tee -a $LOGFILE
        fi
    else
    echo "Directory $DIRECTORY exists." 2>&1 | tee -a $LOGFILE 
    fi

    ## Set rights on folder
    sudo chmod 777 $DIRECTORY
    if [ $? -eq 0 ]; then
        echo "Rights on directory $DIRECTORY set." 2>&1 | tee -a $LOGFILE
    else
    echo "Rights on directory $DIRECTORY could not be set." 2>&1 | tee -a $LOGFILE
    fi
fi

## Copy the files to the correct locations
sudo cp clear.py $DIRECTORY
sudo cp showip.py $DIRECTORY
sudo cp showip.sh $DIRECTORY
sudo cp stopshowipservice.sh $DIRECTORY
sudo chmod -R 777 $DIRECTORY
if [ $? -eq 0 ]; then
    echo "Copied the required files to $DIRECTORY" 2>&1 | tee -a $LOGFILE
else
    echo "Could not copy files to directory $DIRECTORY " 2>&1 | tee -a $LOGFILE
fi

sudo cp $SERVICE /etc/systemd/system
if [ $? -eq 0 ]; then
    echo "Copied the service file to /etc/systemd/system" 2>&1 | tee -a $LOGFILE
else
    echo "Could not copy service file to directory /etc/systemd/system" 2>&1 | tee -a $LOGFILE
fi

## Add the stop mechanism at login.
cat add_bash >> /home/$USERID/.bashrc

## Start and enable the service
sudo systemctl start $SERVICE
if [ $? -eq 0 ]; then
    echo "Service $SERVICE started successfully." 2>&1 | tee -a $LOGFILE
    sleep 2
    sudo systemctl enable $SERVICE
    if [ $? -eq 0 ]; then
        echo "Service $SERVICE enabled successfully." 2>&1 | tee -a $LOGFILE
    else
        echo "Could not enable $SERVICE service." 2>&1 | tee -a $LOGFILE
    fi
    exit 0
else
    echo "Service $SERVICE failed to start" 2>&1 | tee -a $LOGFILE
    exit 1
fi
