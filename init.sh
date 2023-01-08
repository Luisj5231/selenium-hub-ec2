#! /bin/bash

dnf upgrade -y
dnf install python3 podman -y
loginctl enable-linger

