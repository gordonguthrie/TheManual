# Chapter 1 - First beeps

## Setting up Sonic Pi from source

To investigate how Sonic Pi works and become familiar with the code we are going to have do a couple of things:

* install Sonic Pi from source so we can tinker with it
* install the SuperCollider GUI so we can build SuperCollider synths to load into Sonic Pi

The Sonic Pi [github](https://github.com/sonic-pi-net/sonic-pi) has a load of READMEs covering installing on different platforms.

There is a problem tho. When we install Sonic Pi we pull down a SuperCollider server to run but we don't bring the GUI components.

On the Mac OS X - the installed Sonic Pi instance has a pre-built SuperCollider server bundled with it in an executable package. We can just install SuperCollider the app with a GUI alongside it.

With Linux and Raspberry Pi we install the SuperCollider server (but not GUI or CLI) as a dependency alongside our compiled SonicPi.

To muck about with the synths we need to install the other components.

On the Pi we just run:

```
sudo apt-get -y install supercollider
```

for other distros you will need to find the appropriate incantation.

We can now start SuperCollider from the command line:

```
scide
```

