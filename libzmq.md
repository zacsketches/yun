####LibZMQ
This is the process I went through to get libzmq built on Arduino Yun.
I've tried to explain in detail how I did it, but you may need to
look up some commands or other stuff in the man pages on your host
because those man pages are not stored on the Yun to conserve space.

In order to build libzmq on the Yun you must have already followed
a few steps covered previously in my other docs. Specifically, you 
must already expanded the file system (I am using a 32G class U3
SD card) and you must have gotten yun-gcc working.  Additionally,  
you will need to have updated your `/etc/hosts` file to to identify 
the IP address for your youn so that commands like `ssh root@yun` 
know the right IP to connect to.

I was having trouble cloning the git repo for libzmq on the the Yun,
similar to thechallenge described [here](https://walkerlindley.wordpress.com/2014/03/12/arduino-yun-and-git/).

So I got the source, by downloading the zip file on my host 
mac from this [github link](https://zeromq/libzmq/archive/master.zip) and then `scp`'ing it over to the Yun like this:
`scp libzmq-master.zip root@yun:/mnt/sda1`

But `unzip` is not installed by default on the yun to unpack the .zip
file Ijust `scp`'d.  So I used `opkg install unzip`
to remedy that little bump in the road.  After unzipping I noticed that
the ./configure file had was exactly, `configure.ac`, an autoconf
configure script.  You guessed it, `autoconf` is not an available package
for the Yun.

Then after checking some dependencies `autoconf` reuires `libtool` which
in turn requires `GNU M4`.  

So starting from the lowest dependency, I got `M4` from this source:
`http://ftp.gnu.org/gnu/m4/m4-latest.tar.gz` and tried to unpack
the tarball.

But when I did there were all sorts of errors about ownership.
```
...Cannot change ownership to uid 501, gid 20: Operation not permitted
```
I found this [link](http://lime-technology.com/forum/index.php?PHPSESSID=216872a335b2a374d3ede9a4d7311597&topic=22709.msg202225#msg202225) with the recommendation to include
specific calls to `--owner root --group root --no-same-owner`, and 
this fixed the untarring problem.

With the software unpacked I ran `./configure` and it errored out
because the `grep` command that comes with busybox is too 
small to handle long lines.  It needs the *real* grep.

Going back to the wep post by [noblepepper](http://noblepepper.com/wp/blog/2014/10/22/gcc-g-on-an-arduino-yun/) there
is a method there to get the latest `grep`.  I followed his steps
from Sonyyu to use the version of grep in dropbox.  Take a close look
at the filename below, and notice `...ar71xx...` in the name.  This 
ar71xx is the configuration of OpenWRT targted at the Atheros AR9331,
the specifig chip architecture on the Arduino Yun. So someone has cross-
compiled a grep package specifically the Yun.  From my test it's good 
enough to compile M4.  It it fails out on other things I can always go
back and try the full version of grep that Noblepepper finishes up
with.  Get Sonyyu's version at this link:
```
wget -O grep_2.14-1_ar71xx.ipk https://www.dropbox.com/s/a9zuwmh3mipj7jt/grep_2.14-1_ar71xx.ipk?dl=0 --no-check-certificate
```
Once I had installed the new grep, I was able to go back and run
the `./configure`, `make` and `make install` on the M4 source.

But nothing is as easy as it seems.  M4 installs its source in 
`/usr/local/bin` which isn't in the Yun path by default.  So 
I had to create a file in my home directory with
`vim ~/.profile` and add a single line
`PATH=$PATH:/usr/local/bin` in order to get M4 into the search
path.  Once that was done log out of ssh by using `exit` and log
back into the Yun with `ssh root@yun` to get a new shell that reads
the .profile and sets the path.  Then get the rewarding result
`m4 --version`
`m4 (GNU M4) 1.4.17`
`Copyright (C) 2013 Free Software Foundation, Inc.`

Next was libtool.  I got the source for libtool from this link
```
http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.gz
```
Then the obvious steps to `wget` it, untar it and then
`cd libtool-2.4.6` and run `./configure`, `make` and `make install`.
Then after a successful installation you get the rewarding result:
`root@Arduino# libtool --version`
`libtool (GNU libtool) 2.4.6`

Now I had to get the source for autoconf from 
`wget http://ftp.gnu.org/gnu/autoconf/autoconf-latest.tar.gz`
Untar it with the now standard command we've been using:
`tar -xvf autoconf-latest.tar.gz --owner root --group root --no-same-owner`
But when I ran `./configure` it threw a bunch of errors because 
various perl modules were not found.

Then I had to learn about how perl is managed on the Yun.  There
is the obvious package you need to install:
`opkg install perl`

But oh..wait..there is so much more.  I've probably run the configure
and make 

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

