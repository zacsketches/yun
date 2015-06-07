##OpenWRT
#####7 Jun 2015

#####Brick on day one!
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
which point I managed to shut down the wireless and DHCP server and
erased it's self-assigned IP.  So I could not communicate with the 
router anymore.  THUS...
<br><b>I BRICKED IT ON THE FIRST DAY!</b>
<br>So without the ability to communicat with the new router 
via any available interface I went to bed pissed off and wake
up early to ponder the problem over a fresh cup of coffee.

Solution...find a way to connect to the serial console provided
on the PCB inside the router.

## to do

#####`nvram` 
The `nvram` command sets the environment variables for OpenWRT. Once
I got serial comms with the console I needed to updated lots of
the nvram variables so I could reconnect the router to my
system and interact with it more *normally*.
<br><ul>
  <li>`nvram show` lists the variable.</li>
  <li>`nvram set <var_name>=<value>`</li>
  <li>`nvram get <var_name>`</li>
  <li>`nvram commit` save the variables between reboots</li>
</ul>

The first task for me was to understand better how `boot_wait` works.
Supposedly, you can set `boot_wait=on` and the system will pause
during the load process to allow you to connect via `tftp` but I 
wanted to reboot with it on and off to see the difference.

With `boot_wait=on` set and no time variables (i.e. nothing set for
`boot_time` and `wait_time`) there was about a three second pause
saying that it was `READING on 192.168.1.1`.  With `boot_wait=off`
there was no delay.  However, I don't think three seconds is 
going to give me enough time to get my act together on the host
in order to connect over to the router so I am going to give 
the tftp a first tray with some more delay.  By setting the 
`wait_time` varaible to 30 seconds I should be able to get my
act together for a `tftp` transfer.

The next problem I had was connecting to the router.  Even when
it was in its wait state I couldn't ping it, nor could I get
tftp to connect.  So I had to change a few of the dhcp settings

add this
http://wiki.openwrt.org/doc/howto/generic.flashing.tftp

add this
http://downloads.openwrt.org/kamikaze/8.09.2/brcm-2.4/openwrt-brcm-2.4-squashfs.trx




