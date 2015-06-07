##OpenWRT
#####7 Jun 2015

I'm opening this new README under my Yun project because my ulitmate
objective is to run ZeroMQ (perhaps a scaled down version) on the Yun.

I've had such a hard time building libzmq on the Yun natively that
not I'm going to try and build the cross-compilation toolchain and
then flash that image to the Yun.

With that in mind I wanted to go back in the development process a 
little and understand OpenWRT, the base operating system that 
Yun-wrt is based off of.  So I orderd and received a Linksys
WRT54GL wifi/router/switch and the book *WRT54G Ultimate Hacking*.

To start with this book is an outstanding reference for getting 
started with the hardware and the OpenWRT firmware.  The initial
load to move from the Linksys firmware to the the OpenWRT 
software (using a stable older branch 8.09.2)

I installed OpenWRT using the web interface, and messed around
with the way the router was configured to my home network...at
which point I shut down the wireless and DHCP servers and
could not communicate with the router anymore.  THUS...
_I BRICKED IT ON THE FIRST DAY!_
