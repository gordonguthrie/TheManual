# Chapter 2 - How Synths Are Currently Defined And Invoked

## Investigating SonicPi Internals

To mess around with the bit of SonicPi that handles synths you will need to download the source and compile your own instance of SonicPi.

The various markdown files at the root level in the [source code](https://github.com/sonic-pi-net/sonic-pi) have instructions on how to build for many platforms.

For this exploration we will be looking at the `ruby` part of SonicPi.

Luckily once SonicPi is built this is very straightforward. `ruby` is an interpreted and not a compiled language and by simply editing `ruby` source code and stopping and restarting SonicPi we can see the changes.

Once we have compiled a built SonicPi we can start and run it by invoking the binary `sonic-pi` which is created in the directory `app/build/gui/qt`.

Lets look at 2 techniques for understanding what is going on:

* built in messaging inside the runtime
* native Ruby Logging

but before we, beware false friends!

## False Friends

The Sonic Pi language has a couple of ***false friend*** functions - things that look like they will be helpful in this context, but they mostly aren't.

They are the commands `use_debug` and `with_debug` in the language reference. They only affect logging of synth triggers to the front end.

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

This is useful, but not enough for full blown debugging.

## Built in messaging inside the runtime

When we run code in the Sonic Pi like:

```ruby
use_debug false
load_synthdefs "/home/gordon/.synthdefs"

use_synth :myfirstsynth

play 60
```

we see messages on the logging tab like this


```
=> Starting run 3

=> Loaded synthdefs in path: /home/gordon/.synthdefs
   - /home/gordon/.synthdefs/myfirstsynth.scsyndef

=> Completed run 3
```

If we grep the string `Loaded synthdefs` we can find the origin - in the module [sound.rb](https://github.com/sonic-pi-net/sonic-pi/blob/58164cad453458ce0795b01696987e4a2946a451/app/server/ruby/lib/sonicpi/lang/sound.rb#L3357):

```ruby
      def load_synthdefs(path=Paths.synthdef_path)
        raise "load_synthdefs argument must be a valid path to a synth design. Got an empty string." if path.empty?
        path = File.expand_path(path)
        raise "No directory or file exists called #{path.inspect}" unless File.exist? path
        if File.file?(path)
          load_synthdef(path)
        else
          @mod_sound_studio.load_synthdefs(path)
          sep = "   - "
          synthdefs = Dir.glob(path + "/*.scsyndef").join("#{sep}\n")
          __info "Loaded synthdefs in path: #{path}
#{sep}#{synthdefs}"
        end
      end
      doc name:          :load_synthdefs,
          introduced:    Version.new(2,0,0),
          summary:       "Load external synthdefs",
          doc:           "Load all pre-compiled synth designs in the specified directory. This is useful if you wish to use your own SuperCollider synthesiser designs within Sonic Pi.

...
``` 

The function `__info` that is being called to write the msg to the front end is found in the module [runtime.rb](https://github.com/sonic-pi-net/sonic-pi/blob/067a9c7ee2ec2dd839dff054a81112e50326532a/app/server/ruby/lib/sonicpi/runtime.rb#L349):

```ruby
	def __info(s, style=0)
      __msg_queue.push({:type => :info, :style => style, :val => s.to_s}) unless __system_thread_locals.get :sonic_pi_spider_silent
    end
```
We can prove it is this definition by adding another message push as so:

```ruby
	def __info(s, style=0)
      __msg_queue.push({:type => :info, :style => style, :val => "banjo"}) unless       __msg_queue.push({:type => :info, :style => style, :val => s.to_s}) unless __system_thread_locals.get :sonic_pi_spider_silent
    end

```
So now when we stop and start Sonic Pi and run the same code we see that every msg we get in the front end, we get a `banjo` before it.

```
=> Starting run 3

=> banjo

=> Loaded synthdefs in path: /home/gordon/.synthdefs
   - /home/gordon/.synthdefs/myfirstsynth.scsyndef

=> banjo

=> Completed run 3
```
So by simply adding calls to our ruby that calls this `__info` function we can see what's going on when we do stuff.

## Native Ruby Logging


Sometimes, maybe, the front end logging might not be enough.
 
In that case we can use the built in `ruby` [Logger](https://ruby-doc.org/stdlib-2.4.0/libdoc/logger/rdoc/Logger.html).

We can now sprinkle the code with log calls and try and figure out how the server works.

Using [Logger](https://ruby-doc.org/stdlib-2.4.0/libdoc/logger/rdoc/Logger.html) is pretty straightforward, you need to load the library into the module, create a new logger with a fully qualified filename to log to and write a log statement:

```ruby
require 'logger'
...
logger = Logger.new("/home/gordon/Dev/tmp/sonic_pi.log")
logger.debug("normalising synth args")
```

I am telling [Logger](https://ruby-doc.org/stdlib-2.4.0/libdoc/logger/rdoc/Logger.html) to use a file in my home directory, you need to get it write it to wherever suits you. The file must already exist and the path must be fully qualified so no `../..` or `~`s.
