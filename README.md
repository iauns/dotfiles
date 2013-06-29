dotfiles
========

My very own special flavor of unix!

To install it's as simple as:

```bash
source bootstrap
```

Although I would just recommend frolicking around in my dotfiles and
incorporating any humble snippets back into your own.

Special Directories
===================

unused
------

Any files that I'm not currently using are placed in this directory. It is not
symlinked into the home directory.

root
----

Files that belong at the root of the OS. These files are few and far
in-between. These files are not symlinked into the home directory but are
instead symlinked into '/'. When running the bootstrap script you are warned
and asked if you would like to continue before symlinking to '/' occurs.

private
-------

A private git sub-repository. I use this to store my more sensitive files like
my email setup and some SSH settings.

Inspirations
============

The configuration used in my dotfiles repo is a balance between [Zach
Holman's](https://github.com/holman/dotfiles.git) and [Mathias
Bynen's](https://github.com/mathiasbynens/dotfiles.git) dotfiles with more of
the bootstrapping code stolen from Zach.

See some great examples of dotfiles are listed http://dotfiles.github.io/ .
