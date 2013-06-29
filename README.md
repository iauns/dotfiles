dotfiles
========

My very own flavor of unix.

Special Directories
===================

unused
------

Any files that I'm not currently using, but I have in the past, are placed in
this directory. It is not symlinked into the home directory.

root
----

Files that belong at the root of the OS. These files are few and far
in-between. Like 'unused' these files are not symlinked into the home
directory but are instead symlinked into '/'. When running the bootstrap
script you are warned and asked if you would like to continue before
symlinking to '/' occurs.

private
-------

A private git sub-repository. I use this to store my more sensitive files. For
example, my mail setup (not including passwords) and some SSH settings
(not including private keys).

Inspirations
============

The configuration used in my dotfiles repo is a balance between [Zach
Holman's](https://github.com/holman/dotfiles.git) and [Mathias
Bynen's](https://github.com/mathiasbynens/dotfiles.git) dotfiles with more of
the bootstrapping code stolen from Zach.

See some great examples of dotfiles are listed http://dotfiles.github.io/ .
