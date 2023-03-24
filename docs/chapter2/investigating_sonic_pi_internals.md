# Chapter 2 - How Synths Are Currently Defined And Invoked

## Investigating SonicPi Internals

To mess around with the bit of SonicPi that handles synths you will need to download the source and compile your own instance of SonicPi.

The various markdown files at the root level in the [source code](https://github.com/sonic-pi-net/sonic-pi) have instructions on how to build for many platforms.

For this exploration we will be looking at the `ruby` part of SonicPi.

Luckily once SonicPi is built this is very straightforward. `ruby` is an interpreted and not a compiled language and by simply editing `ruby` source code and stopping and restarting SonicPi we can see the changes.

Once we have compiled a built SonicPi we can start and run it by invoking the binary `sonic-pi` which is created in the directory `app/build/gui/qt`.

SonicPi has debug logging written into the code and getting them to fire will help us get to know how the system works.

There is a command `use_debug` which you can use in the GUI (its described in the `Lang` section of the help). By default it is on.

If we run the following code in the SonicPI gui:

```ruby
use_synth :bass_foundation

play 60
```

we see the following log message in the log window of the GUI:

```
=> Starting run 6

{run: 6, time: 0.0}
 └─ synth :bass_foundation, {note: 60.0}
```

If we now add the `use_debug` command the log message goes away:
 
```ruby
use_debug false
use_synth :bass_foundation

play 60
```

We will want that log info as we investigate synths, so lets keep it on.
 
To dig into SonicPi we will use the built in `ruby` [Logger](https://ruby-doc.org/stdlib-2.4.0/libdoc/logger/rdoc/Logger.html).

We can now sprinkle the code with log calls and try and figure out how the server works.

Using [Logger](https://ruby-doc.org/stdlib-2.4.0/libdoc/logger/rdoc/Logger.html) is pretty straightforward, you need to load the library into the module, create a new logger with a fully qualified filename to log to and write a log statement:

```ruby
require 'logger'
...
logger = Logger.new("/home/gordon/Dev/tmp/sonic_pi.log")
logger.debug("normalising synth args")
```

I am telling [Logger](https://ruby-doc.org/stdlib-2.4.0/libdoc/logger/rdoc/Logger.html) to use a file in my home directory, you need to get it write it to wherever suits you. The file must already exist and the path must be fully qualified so no `../..` or `~`s.
