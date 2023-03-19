# Chapter 2 - How Synths Are Currently Defined And Invoked

## Investigating SonicPi Internals

To mess around with the bit of SonicPi that handles synths you will need to download the source and compile your own instance of SonicPi.

The various markdown files at the root level in the [source code](https://github.com/sonic-pi-net/sonic-pi) have instructions on how to build for many platforms.

For this exploration we will be looking at the `ruby` part of SonicPi.

Luckily once SonicPi is built this is very straightforward. `ruby` is an interpreted and not a compiled language and by simply editing `ruby` source code and stopping and restarting SonicPi we can see the changes.

To dig into SonicPi we will use the built in `ruby` [Logger](https://ruby-doc.org/stdlib-2.4.0/libdoc/logger/rdoc/Logger.html).

We can now sprinkle the code with log calls and try and figure out how the server works.

Using [Logger](https://ruby-doc.org/stdlib-2.4.0/libdoc/logger/rdoc/Logger.html) is pretty straightforward, you need to load the library into the module, create a new logger with a fully qualified filename to log to and write a log statement:

```ruby
require 'logger'
...
logger = Logger.new("/home/gordon/Dev/tmp/sonic_pi.log")
logger.debug("normalising synth args")
```
