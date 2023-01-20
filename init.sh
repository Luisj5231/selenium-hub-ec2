#! /bin/bash

dnf upgrade -y
dnf install python3 podman -y
loginctl enable-linger #This fix from containers going down after closing ssh session.

