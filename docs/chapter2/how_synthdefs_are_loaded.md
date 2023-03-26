# Chapter 2 - Existing synths in Sonic Pi

## How Synthdefs are loaded

Lets go hunting for the code that loads synth definitions and see what it does.

Using a combination of the logging techiques in the previous section we can soon find out roughly how it works.

The very earliest message we see in the GUI is:

```
=> Welcome to Sonic Pi v5.0.0-Tech Preview 2
```

This message is sent from the [runtime module](https://github.com/sonic-pi-net/sonic-pi/blob/dev/app/server/ruby/lib/sonicpi/runtime.rb#L558):

```ruby
  def __load_buffer(id)
      id = id.to_s
      raise "Aborting load: file name is blank" if  id.empty?
      path = File.expand_path("#{Paths.project_path}/#{id}.spi")
      s = "# Welcome to Sonic Pi\n\n"
      if File.exist? path
        s = IO.read(path)
      end
      __replace_buffer(id, s)
    end
```

That function `__load_buffer` is called in one place and one place only, by the [spider server](https://github.com/sonic-pi-net/sonic-pi/blob/dev/app/server/ruby/bin/spider-server.rb).

We know that the `spider-server` is special because it sits in `app/bin` and not `app/server/ruby/lib/sonicpi` like the rest of the ruby code.

Spider has its own log in `~/.sonci-pi/logs` and if we look at them:

```
Sonic Pi Spider Server booting...
The time is 2023-03-26 13:02:47 +0100
Using primary protocol: udp
Detecting port numbers...
Ports: {:server_port=>37064, :gui_port=>37065, :scsynth_port=>37066, :scsynth_send_port=>37066, :osc_cues_port=>4560, :tau_port=>37067, :listen_to_tau_port=>37071}
Token: 520542600
Opening UDP Server to listen to GUI on port: 37064
Spider - Pulling in modules...
Spider - Starting Runtime Server
TauComms - Sending /ping to tau: 127.0.0.1:37067
TauComms - Receiving ack from tau
TauComms - connection established
studio - init
scsynth boot - Waiting for the SuperCollider Server to have booted...
scsynth boot - Sending /status to server: 127.0.0.1:37066
scsynth boot - Receiving ack from scsynth
scsynth boot - Server connection established
scsynth - clear!
scsynth - clear schedule 
scsynth - schedule cleared!
scsynth - group clear 0
scsynth - group clear 0 completed
Studio - Initialised SuperCollider Audio Server v3.11.2
Studio - Resetting server
Studio - Reset and setup groups and busses
Studio - Clearing scsynth
scsynth - clear schedule
scsynth - clear scsynth
scsynth - clear!
scsynth - clear schedule 
scsynth - schedule cleared!
scsynth - group clear 0
scsynth - group clear 0 completed
scsynth - cleared scsynth
scsynth - bus allocators reset
Studio - Allocating audio bus
Studio - Create Base Synth Groups
Studio - Starting mixer
Studio - Starting scope
Spider - Runtime Server Initialised
Spider - Registering incoming Spider Server API endpoints
Spider - Booted Successfully.
Spider - v5.0.0-Tech Preview 2, OS raspberry, on Ruby  2.7.4 | 2.7.0.
Spider - ------------------------------------------
```

The SonicPi server is all set up by the module [studio.rb](https://github.com/sonic-pi-net/sonic-pi/blob/dev/app/server/ruby/lib/sonicpi/studio.rb#L25).

The intialise function

