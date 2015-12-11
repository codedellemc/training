#!/bin/bash
useradd -s /bin/bash -m -d /home/$HOSTNAME  -g root $HOSTNAME
echo -e "$HOSTNAME\n$HOSTNAME\n" | sudo passwd $HOSTNAME
sed -i '20 a '"$HOSTNAME"'    ALL=(ALL:ALL) ALL' /etc/sudoers
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
gpasswd -a ${HOSTNAME} docker
reboot