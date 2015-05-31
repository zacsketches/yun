I've got a README started for my networking education on the
desktop, but I wanted to add some notes from my laptop about
what I've been doing the last few days.  Next will be to get ssh
up and running so I can use the same README regardless of where
I'm working.

-----------------------
23 May

Spent a great day with Parker, a warm fire, good coffee and learning
to be a better programmer.  I'm starting to peel the onion back
on implementing networked systems and getting into more of the
new stuff in C++11.  Some key topics I reviewed/learned yesterday were:

Concurrency - 
	Although the ZeroMQ guys are against using any form of mutex
and/or semaphores in creating multithreaded programs, I thought it 
was essential to my understanding of concurrency to explore the
facilities provided in <atomic> and <thread> so I had some first
hand knowledge of how those facilities work.  
	I implemented a multithreaded hello world client and MT 
server in ZMQ.  This required launching the threads and keeping 
handles to them in a vector and then synching the threads with
.join().  Additionally, on the client I implemented a mutex to 
control access to std::cout and an atomic<int> counter so I could
get system wide counts of how many messages were sent.

Virtualization - 
	In order to implement networking on my laptop I also wanted
to get a few virtual machines up and running.  So I went back to
VirutalBox which I had looked at before, but not istalled.  I got 
it up and running and created a Debian image.  The .iso OS file and
the folder for the virtual machine hard drive are both in my
Volumes/User-data/ folder.
	From this virtual machine I was able to build a simple
ZMQ client and interact with the host OS ZMQ server using the
assigned IP address for the host as the .connect(tcp...) point.

Embedded Capability -
	I am still targeting the capability to implement ZMQ on 
the PRC-152 ANW2C waveform and/or the lower hanging fruit of 
implementing it on Reticle.  In order to do that I've got to 
start getting ready to cross compile some executables for other
hardware environments.  With that in mind I have several tasks that
I need to get more familiar with:
	- file transfer between my host OS and my target
	- setting up a cross compiler
	- creating the buildroot environment
Finally, I've got an Arduino Yun on the way.  This board has the
Atheros 9331 chip loaded with OpenWRT.  Over the course of the next
week I need to be able to build OpenWRT from source and load the
new firmware onto the Yun.  This will give me to foundation to
start trying to add new capability to the firmware.

-----------------------
24 May

Looking forward to another great day on the computer.  Perfect morning!
Flirted with Elissa a little bit on my phone, and I'm excited to 
get her and the rest of the family out to California.  We are
still able to connect from far away, but it gets more strained as
our separation approaches two years.  This is a phase of our marriage
and our life that I don't ever want to repeat.  

Right now Parker is studying for her pre-calculus final next week and
I enjoy spending time 'next' to her even if we aren't talking all
that much.  She like my help on her math, but my 'long' answers
are not always appreciated.

MAC admin -
	today I invested a little more time in Homebrew and really 
like it as the best package management system I've come across.  I
installed the caskroom which lets you keep track of GUI packages
and I'm happy about it becauseit represents the same easy to see
list of software that I get from CLI apps.  See this link for
more info: http://caskroom.io/

UNIX admin -
	Couple of new commands and tools I want to document my new
familiarity with.  Setting up Debian for the first time yesterday
there was a bunch of stuff that took a while to get more familiar 
with.
	ifconfig - Debian has this in /sbin/ so it needs to run as
root in order see network configuration.  
	/sbin - generally the purpose of files and the more common
ones are described well here: http://www.linfo.org/sbin.html
	launctld - check out the man page on this one to see more
about all daemons running on the system and how to control them.
	apt-cache - does not require sudo and has options for 
`search` and `show` to find packages.
	apt-get - runs under sudo for options `install`
	ldconfig - see the man page, but I was using this to try
and get libzmq available to gcc.  I didn't have any luck in getting
the -lzmq option to build right.  I had to specify the full path
to the library even though ldconfig lists the library as an option
	su - swith user.  With no arguments this switches to root.
had to run as root to create/modify the sudo group
	adduser - as root this command was necessary to add `zac` to
the sudo group
	lld - gives library dependencies of another library or object
file.  You can use this to see what libs a binary was linked against.
See the Mac verion of otool -L.
	file - shows the file type...useful for seeing how a binary
was compiled.

Virtualization continued -
	Today I want to add an FTP server to my virtual machine and
I want to move the git repos I'm tracking into a src folder.  This may
break some sym links I've built but I want to keep the directory
tree pretty clean so I can tell what I've done.
	I was able to ping my host from the VM yesterday, but going 
the other way today I was unable to ping the VM from the host or anywhere
else on the network.  I found the solution on this post:
	https://forums.virtualbox.org/viewtopic.php?f=6&t=34563&p=322575#p322575
After changing from NAT to bridge mode on the VM network adapter I can
ping and connect from the ZMQ client on the host to the ZMQ server
on the Guest. 	
	I moved the git sources I've downloaded into the ~/src directory
so I can periodically check to make sure I'm up to date.  I then had
to update the sim linds in /usr/include to point at the correct
location for the header files.
	After I got the pure-ftpd running on my vm I can move files
back and forth from my Debian Guest to my OS X host.  So I tried
to run an executable build on the debian system on the OS X host
and got the expected behaviour that it won't work...Yay!  The next
step is to build a cross compiler on my mac that will allow me to 
compile for my debian vm.

OpenSSL -
	both FTP clients I'm looking at pro-ftpd and pure-ftpd have a
homebrew option so that will allow me to run the same ftp solution on 
my laptop and virtual machine.  However, both require openssl which 
Apple has deprecated in favor their own TLS and crypto libraries.
	Brew informed me that this install is "keg only" which means it
isn't linked into /usr/local.  So this means I'll have to include these
flags when/if I need to build with it:
	LDFLAGS:   -L/usr/local/opt/openssl/lib
	CPPFLAGS:  -I/usr/local/opt/openssl/include
Additionally, the CA file was bootstrapped from certificates on the
system.  To add additionaly certificates, place .pem files in 
	/usr/local/etc/openssl/certs
and then run
	/usr/local/opt/openssl/bin/c_rehash

Pkg-config - 
	need to take a look at using pkg-config.  If I'm going to be
building form source I think this tool may help me. See the website
at: http://people.freedesktop.org/~dbn/pkg-config-guide.html
I've installed this on both the mac and devianVM, but unfortunately 
there aren't a lot packages that use it.

Libsodium - 
	This is going to be the crypto library I use in my own code.
OpenSSL is tough to build and tough to understand.  ZMQ uses sodium
natively and from what I've seen of the API it seems to be EASY which
I never felt trying to learn OpenSSL

Pure-ftpd -
	Okay...after reading for a while this morning instead of diving
right into it I think I'm goign to go with Pure-ftpd over Proftpd.
Pure is a little less feature rich which should be fine for my personal
use and just for compatibility's sake it is listed as a project in the
same group as libsodium.  So I think I'm going to 'stay in the family' 
as it were.
	I installed on the Debian system via the package manager and 
it put the files into /usr/sbin as described in the guide on their
web page: pureftpd.org
	The serve is launched at login from the listing in 
/etc/init.d/pure-ftpd*
	To see who is logged in /etc/sbin pure-ftpwho
	To see status /etc/intit.d/pure-ftpd status
	To login locally `ftp localhost`
	To see processes ps auwx|grep pure-ftpd
	To log in from my mac its `ftp <guest ip>`
I can route packets inside my own network on DHCP provided addresses
10.0.0.X but I will have to set up port forwarding on the router if
I want to come at my ftp server from further away.
	SUCCESSS!! I'm moving files between my mac and debian vm 
with no problem and should be able to do the same to move files
via FTP to the Yun when it arrives.

Cross Compiler -
	Okay...this is the next big challenge for me today!  I need
to build a cross compiler that lets me build for a target arch
different than the host.  Since this is the first time I'm doing 
this I will take it either way Mac->Deb or Mac<-Deb.

Yun -
	I've got a busy few days ahead learning to use the Yun.  Some
links of interst that I'm going to want to come back to:
	http://forum.arduino.cc/index.php?topic=266549.0
	http://tavendo.com/blog/post/arduino-yun-with-autobahn/
	http://noblepepper.com/wp/blog/2014/10/22/gcc-g-on-an-arduino-yun/
	http://is.gd/1jUPNF
	http://forum.arduino.cc/index.php?topic=253943.msg1799995#msg1799995
	https://github.com/arduino/openwrt-yun/blob/master/ChangeLog
Steps:
	1. Flash new firmware as described on the top of the forum page
	2. Install gcc
	3. Build libzmq - follow inst here http://zeromq.org/intro:get-the-software
	
##27 May
###Yun  
I've got my Yun hooked up and I'm learning some quick lessons.  Some of this
is documented on the forum and some of it assumes various levels of 
experience with linux and OpenWRT.  So I'm going to record my path here from
switching it on for the first time all the way through compiling a custom
library for libzmq.
####Power up
First things first. When I powered the yun on by plugging a micro-USB into the jack it lit up.
####Firmware
Next the [forum](http://forum.arduino.cc/index.php?board=93.0) indicates that the very first thing a new user should do is verify their firmware is the latest build.  I used the command

  	`uname -a` 

and saw that the firmware upgrade was from April 2014.  The newest image off the the [change page](https://github.com/arduino/openwrt-yun/blob/master/ChangeLog) is Nov 2014. So I downloaded the new image and then had to move it to the SD card

	`scp /openwrt.newest.edition root@yun:/mnt/sda1`

Then

	`run-sysupgrade /mnt/sda1/openwrt`

Because the system changes the RSA key with the new software the next time
you ssh in after the upload I was locked out and warned by ssh running 
on OS X that I may be the target of a man-in-the-middle attack.  This is not
the case...this time...I haven't gotten to that yet :-).  So open 

	`/Users/username/.ssh/known_hosts` 

and delete everything there for the Yun.
Then try ssh again and confirm "yes" that you want to log into the 
now unknown host.  Then run
	`uname -a`
with the expected result:

	`Linux Arduino 3.3.8 #1 Fri Nov 14 08:57:34 CET 2014 mips GNU/Linux`

Then I couldn't run `opkg update` because the clock is wrong and won't 
synch the right signature file.  Update the clock by going to 
this [live clock](http://liveclock.net) and updating the Yun with
`date --set <time>`.

##28 May
###Yun Continued

####Get GCC compiling on Yun
This was a learning curve.  Had to expand the root file system with the e2fsprogs package.  I used the sketch from the arduino site, but the openwrt site and the forum have some good insight on the way to do it manually.
Next I want to get this stuff working.

	http://forum.arduino.cc/index.php?topic=266549.15

	http://forum.arduino.cc/index.php?topic=266549.15

##29 May
###Yun Continued

####File system

I did not understand the disk partition stuff that I did yesterday so i read a little more about e2fprogs and the ext2 filesystem.  This site on mounting and unmounting devices was useful.

	http://www.thegeekstuff.com/2013/01/mount-umount-examples/

##30 May
###Mac-Unix Admin
####Launch Control

In my effort to bounce back and forth between 0MQ, Yun and better OS X / Linux sysadmin
skills I spent some time today learning how OS X uses the `launchctl` program to 
manage the launch daemon.  This process deprecates `cron` for OS X.  

My use case is just launching a terminal window when I log in as my development user.
I started by reading this link on [launchd](http://alvinalexander.com/mac-os-x/mac-osx-startup-crontab-launchd-jobs).

Then I read `man launchctl`, `man launchd`, and `man launchd.plist`.

At this point I felt pretty confident to write a .plist file to launch the
Terminal application and store this .plist file in the 
`~/Library/LaunchAgents/` directory.

To actually write the .plist XML file I chose not to open a text editor and 
go at it manually.  Instead I used XCode and created a File->New..
Then look for OS X->Resource->Property List.  This will open an XCode tool
to add tags to a preformatted file and save a lot of typing and potential 
formatting errors in the XML syntax.  From the documentation I knew I needed
the `Label` tag, the `Program` tag and the `RunOnLoad` tag.  After saving this
file and inspecting the text version via `cat *.plist` in the terminal window:
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>zac.example.appload</string>
	<key>Program</key>
	<string>/Applications/Utilities/Terminal.app/Contents/MacOS/Terminal</string>
	<key>RunAtLoad</key>
	<true/>
</dict>
</plist>
```
<h6>Voila!</h6> <p>This launches a Terminal window when I log in as desired.</p>

###Yun
####C++11 
I like the concurrency in C++11 for ZeroMQ so I want to try and get c++11 compiling
on the Yun.  My first attempt was a simple program to test basic c++11 
functions.
```
//
// Test c++11 on yun
//
#include <iostream>
#include <vector>

using namespace std;

int main() {
	vector<int> vi;
	vi.push_back(3);
	vi.push_back(5);
	vi.push_back(7);
	
	for(auto x : vi) {
		cout<<"The value is: "<<x<<endl;
	}	
}
```
Compile with `g++ -std=c++0x hw_11.cpp -o hello_11` and get expected results:
```
root@Arduino:~/test_c# ./hello_11
The value is: 3
The value is: 5
The value is: 7
```
Moving on to this program that uses the <thread> and <chrono> library was
not as easy.
```
//
// sleep_11.cpp
// Test c++11 on yun with some of the more recent libraries
//
#include <iostream>
#include <vector>
#include <chrono>
#include <thread>

using namespace std;

int main() {
	vector<int> vi;
	vi.push_back(3);
	vi.push_back(5);
	vi.push_back(7);
	
	for(auto x : vi) {
		cout<<"The value is: "<<x<<endl;
		this_thread::sleep_for(chrono::seconds(1));
	}	
}
```
Compiling with `g++ -std=c++0x sleep_11.cpp  -o sleep` give the error:
```
sleep_11.cpp: In function 'int main()':
sleep_11.cpp:20:3: error: 'sleep_for' is not a member of 'std::this_thread'
```
I'm thinking this is a library error.  So I tried
```
root@Arduino:~/test_c# g++ -print-libgcc-file-name
/usr/bin/../lib/gcc/mips-openwrt-linux-uclibc/4.6.2/libgcc.a
```
So the default library for c++ compilation is the uclibc library.  My 
guess is that the uclibc library doesn't contain the full set
of facilities for concurrency.  So I used `opkg list-installed | grep libstdcpp`
and found that `libstdcpp` was not installed, but when I tried
`opkg install libstdcpp` I got the following errors:
```
 * check_data_file_clashes: Package libstdcpp wants to install file /usr/lib/libstdc++.so.6.0.16-gdb.py
	But that file is already provided by package  * yun-gcc
 * check_data_file_clashes: Package libstdcpp wants to install file /usr/lib/libstdc++.so.6.0.16
 * opkg_install_cmd: Cannot install package libstdcpp.
 ```
 Just figured out I'm barking up the wrong tree.  From this link on 
 [stackoverflow](http://stackoverflow.com/questions/12523122/what-is-glibcxx-use-nanosleep-all-about) its pretty clear that the issue is in GCC.
 So I took the total hack and added `#define _GLIBCXX_USE_NANOSLEEP`
 to the top of the file and it compiled fine with the expected output
 that there was 1 second pause between printing each member in the
 vector<int>.
 
 But in order to try and do it right, I need to figure out how to 
 rebuild Yun-GCC with the `--enable-libstdcxx-time`
 
####LibZMQ
I need to try this [link](https://walkerlindley.wordpress.com/2014/03/12/arduino-yun-and-git/) to get the source code onto the Yun.

So I got the source, by downloading the zip file on my host 
mac, and then `scp`'ing it over to the Yun.  
But when I unzipped it there were all sorts of errors about ownership.
```
...Cannot change ownership to uid 501, gid 20: Operation not permitted
```
I found this [link](http://lime-technology.com/forum/index.php?PHPSESSID=216872a335b2a374d3ede9a4d7311597&topic=22709.msg202225#msg202225) with the recommendation to include
specific calls to `--owner root --group root --no-same-owner`, and 
this fixed the untarring problem.

Now LibZMQ requires `autoconf`.
But `autoconf` depends on `libtool` which depends on `GNU G4`.

So I got the source for G4 at `http://ftp.gnu.org/gnu/m4/m4-latest.tar.gz`
Ran `.\configure` successfully.  Then `make` and `make install`.  All
worked and now I've got `M4` installed on the Yun from source.

Next, I switched over to the libtool directory and again ran 
`./configure`, `make` and `make install`.  Again it all worked so 
now there is `libtool` available.

Now I had to get the source for autoconf from 
`wget http://ftp.gnu.org/gnu/autoconf/autoconf-latest.tar.gz`
But when I ran `./configure` it threw an error because perl was not
found.

I should be able to get perl via opkg.  Yep...found perl and installed
it via `opkg install perl`.

Then went back and ran`./configure` for autoconf again with success.
But when I ran `make` it errore out with this:
`Can't locate Data/Dumper.pm in @INC`

Start by running `opkg install perlbase-base`.
Run `opkg list | grep perlbase-` to see the list of perl modules available.

And after some other dependency checking you also need Extutils and
strict.pm.
`opkg install perlbase-data`
`opkg install perlbase-extutils`

..then that failed because it lacked `strict.pm`

But not I didn't see a module for strict; however,
I found a link on the [forum](http://forum.arduino.cc/index.php?topic=220344.msg1772282#msg1772282) that explains
how to get the source for strict.pm and install it directly into the right 
spot.  Get the source [here](http://cpansearch.perl.org/src/SHAY/perl-5.20.2/lib/strict.pm)

