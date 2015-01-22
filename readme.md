Firmware builder is from
https://code.google.com/p/rcc/source/browse/trunk/projects/rt5350_mini_router/OpenWrt-ImageBuilder-ramips_rt305x-for-linux-x86_64.tar.bz2

Note:
The commands inside the scripts were compiled for x64 only, so you need to run that on x64 Linux.
The vmlinux that comes with the scripts was hardcoded for 16MB of SDRAM and it ignores the u-boot argument.
I had to replace the command line parameter (in text) from 16M to 32M inside vmlinux with a hex editor. 
vmlinux is under "build_dir/target-mipsel_r2_uClibc-0.9.33.2/linux-ramips_rt305x/"

I modified one of the entries in the build script: "image_builder_rt5350.sh" located at the root of the package. 
This builds a wifi router with luci web interface and has opkg and USB mass storage support.

