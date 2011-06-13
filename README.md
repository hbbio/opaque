opaque: blogging software written in OPA
========================================

`opaque` is some simple blogging software written in OPA that I'm
writing for [projectaweek](http://projectaweek.heroku.com/). I got an
invite, so I might as well use it!

Features
--------

 * MathJax support (uses mathjax CDN)
 * Syntax highlighting - for Haskell only at the moment (via [shjs](http://shjs.sf.net).)
 * Markdown support via [upskirt](https://github.com/tanoku/upskirt).

Building
========
You shouldn't need anything special if you have OPA installed. Just do:

     $ make

And you have `opaque.exe` waiting for you.

If you want to run with `opa-cloud` (see below) you'll also need
haproxy installed on the machine that will start the distribution and
do load balancing:

     $ brew install haproxy # homebrew
     $ aptitude install haproxy # deb/ubuntu
     $ yum install haproxy # fedora
     # etc...

Supported platforms
-------------------

POSIX only at the moment. You'd just need to replace the
`getrusage()`/`uname()` usage inside the native binding to make it
work somewhere else, really. Alas, OPA isn't available for windows yet
anyway.

Configuring
===========

Edit the variables in the top-level `config.opa` file for your blog.

Running
=======

After you've built it, you can either do:

     $ make run

Or simply:

     $ ./opaque.exe

which will start the HTTP server on port 8080 by default. Admin
password will be generated on the first run, and output to server
debug console (see 'Destroying DB data' to clean it.)

RUN IN THE CLOUD! THE CLOOOOOUUUD
---------------------------------

Naturally your blog is so popular (due to *you* being *awesome*) that
any normal server by its lonesome would never be able to handle the
relentless onslaught of crazed visitors 24/7. Let the cloud save you:

     $ make cloud CLOUD_OPTS=...

where 'CLOUD_OPTS' are the options you would normally give to
`opa-cloud`. By default it just launches two instances on
localhost. Make sure your own ssh public key is in your
`~/.ssh/authorized_keys`:

     $ cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys

Example: I have two debian machines, `pylon1` and `pylon2`. It's easy to run the system
on both of them by doing:

     $ make cloud CLOUD_OPTS="--host pylon1 --host pylon2 --haproxy /usr/sbin/haproxy"

Note the path to `haproxy`, which on debian at least will be in
`/usr/sbin` which resides outside of `$PATH` by default.

After doing this, you can independently browse to each server with or
without the proxy (e.g. `http://pylon1:8080` or `http://pylon1:8081`
or `http://pylon2:8081`) and you'll still get things like realtime
updates, even on different servers (try it yourself!)

Destroying DB data
==================

If you want to clean everything, run:

     $ make clean-db

Bugs & Misc
===========

 * Email encryption/obfuscation would be nice (without running upskirt on
   every page render; is there a way to do that at compile time?)
 * No RSS
 * Google analytics would be nice
 * There's some weird behavior with mathjax ATM where you need to
   double-escape backslashes in order to use inline/block style
   math. So, don't use `\[\alpha\]`, use `\\[\alpha\\]` and it should
   mostly work. Needs to be fixed.
 * The Upskirt binding is bound via OCaml. It could probably be useful
   in its own right, but I don't know how to get it out there (put it
   on GODI I guess?)
