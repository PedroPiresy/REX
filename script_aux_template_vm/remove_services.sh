#!/bin/bash

# Desabilita o ajuste de host via API ovirt
systemctl disable configure-host.service
rm -rf /usr/local/bin/configure_host.sh

# Desabilita o ajuste de disco via GrowPart
systemctl disable resize-disk.service
rm -rf /usr/local/bin/resize_disk.sh

# Restarta o systemctl

systemctl daemon-reload
