##OpenWRT
#####7 Jun 2015

#####Brick on day one!
I'm opening this new README under my Yun project because my ulitmate
objective is to run ZeroMQ (perhaps a scaled down version) on the Yun.

I've had such a hard time building libzmq on the Yun natively that
now I'm going to try and build the cross-compilation toolchain and
then flash that image to the Yun.

With that in mind I wanted to go back in the development process a 
little and understand OpenWRT, the base operating system that 
Yun-wrt is based off of.  So I orderd and received a Linksys
WRT54GL wifi/router/switch and the book *WRT54G Ultimate Hacking*.

To start with, this book is an outstanding reference for getting 
started with the hardware and the OpenWRT firmware.  The initial
load to move from the Linksys firmware to the the OpenWRT 
software (using a stable older branch 8.09.2) went smoothly exactly
as it was described in the book.

I installed OpenWRT using the web interface.  Then I got off the reservation
and started messing around
with the way the router was configured to my home network...at
which point I managed to shut down the wireless and DHCP server and
erased it's self-assigned IP.  So I could not communicate with the 
router anymore.  THUS...
<br><b>I BRICKED IT ON THE FIRST DAY!</b>
<br>So without the ability to communicate with my new router 
via any available interface I went to bed pissed off and woke
up early to ponder the problem over a fresh cup of coffee.

Solution...find a way to connect to the serial console provided
on the PCB inside the router.

## TODO: add photos and description of the hardware hack

Once the cable is built connect to the root console via the
`screen </dev/name> 115200`

#####`nvram` 
Once I regained root access I wanted to start learning about the
Linux environment in the router.  `nvram` is that start of that journey.

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

With `boot_wait=on` and no time variables (i.e. nothing set for
`boot_time` and `wait_time`) there was about a three second pause
saying that it was `READING on 192.168.1.1`.  With `boot_wait=off`
there was no delay.  However, I don't think three seconds is 
going to give me enough time to get my act together on the host
in order to connect over to the router so I am going to give 
tftp a try with some more delay.  By setting the 
`wait_time` varaible to 30 seconds I should be able to get my
act together for a `tftp` transfer.

The next problem I had was connecting to the router.  Even when
it was in its wait state I couldn't ping it, nor could I get
tftp to connect.  So I had to change a few of the dhcp settings

My solution was to re-enable DHCP so I could plug an ethernet
cord into the router and it would provide an ip address to my mac.
Create a record in `/etc/init.d/` called `S60dnsmasq`.  This 
record is short and points to the config file which controls DNS and DHCP.
```
#!/bin/sh
# S60dnsmasq
dnsmasq -C /etc/dnsmasq.conf
```
Then I had to restart the dnsmasq with `killall dnsmasq` followed by
running the new script `/etc/init.d/S60dnsmasq`

Once this was up and running I could then run an ethernet cable 
from my mac-mini to the WRT and it would serve a DHCP ip address to 
the mac and I could ping it.

Then I plugged the WRT wan port into my DOCSIS xfinity modem so 
that the switch would keep both link layers alive.  Then I could ping
from from the wrt console -> to the xfinity modem **and** from to
wrt console -> mac.

I had to delete any `arp` records related to the old setup on my mac
which were blocking comms with tftp.  With that flushed I could
reboot on the wrt_console and then initiate tftp from the mac.

I also wrote a little script to automate the tftp process and requires
less typing.  See `wrt_tftp.sh` in the roote of this repo.

Once the router begins rebooting run the script from the same folder
that contains the <wrt_firmwar.bin> file you want to upload.

####Chapter 3, Using OpenWRT




