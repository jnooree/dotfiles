#!/bin/bash

set -euo pipefail

# macos-speedup script
curl -fsSL https://gist.github.com/jnooree/ecb0169a573842af7738efd1347028d3/raw/macos-speedup.sh |
	bash

# Power management
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
