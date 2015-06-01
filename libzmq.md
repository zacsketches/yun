####LibZMQ
This is the process I went through to get libzmq built on Arduino Yun.

I was having trouble cloning the git repo for libzmq similar to the 
challenge described [here](https://walkerlindley.wordpress.com/2014/03/12/arduino-yun-and-git/) to get the source code onto the Yun.

So I got the source, by downloading the zip file on my host 
mac from this [github link](https://zeromq/libzmq/archive/master.zip) and then `scp`'ing it over to the Yun.  

But `unzip` is not installed by default so I used `opkg install unzip`
to remedy that little bump in the road.  After unzipping I noticed that
the ./configure file had was exactly, `configure.ac`, and autoconf
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
from Sonyyu to use the version of grep in his dropbox.  It's good 
enough to compile M4.  It it fails out on other things I can always go
back and try the full version of grep that Noblepepper finishes up
with.  Get Sonyyu's version at this link:

wget -O grep_2.14-1_ar71xx.ipk https://www.dropbox.com/s/a9zuwmh3mipj7jt/grep_2.14-1_ar71xx.ipk?dl=0 --no-check-certificate

Once 

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

