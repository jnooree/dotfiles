#!/bin/bash

set -euo pipefail

# macos-speedup script
curl -fsSL https://gist.github.com/jnooree/ecb0169a573842af7738efd1347028d3/raw/macos-speedup.sh |
	bash

# Power management
sudo pmset -a tcpkeepalive 1
sudo pmset -a ttyskeepawake 1
sudo pmset -a womp 1

if ioreg -r -k BatteryInstalled | grep -iq 'BatteryInstalled.*No'; then
	# No battery, likely to be a desktop
	sudo pmset -a powernap 1
	sudo pmset -a gpuswitch 2
	sudo pmset -a sleep 0
	sudo pmset -a disksleep 0
	sudo pmset -a displaysleep 15
else
	sudo pmset -b powernap 0
	sudo pmset -b gpuswitch 0
	sudo pmset -b sleep 15
	sudo pmset -b disksleep 10
	sudo pmset -b displaysleep 5

	sudo pmset -c powernap 1
	sudo pmset -c gpuswitch 2
	sudo pmset -c sleep 30
	sudo pmset -c disksleep 30
	sudo pmset -c displaysleep 15
fi
