# Chapter 1 - First Beeps

## First Synth In Sonic Pi

We will make this oscillator into a synthesiser that we can use in Sonic Pi:

```supercollider
{SinOsc.ar(440, 0, 0.2)}.play;
```

If we run this definition in Super Collider we can get a synth that we can play in Sonic Pi. Notice that it is writing the synthdef to a default location in my home directory (on a Mac) where Sonic Pi will find it - you will need to put your home directory in whatever operating system you use into that path.

```supercollider
(SynthDef("myfirstsynth", {arg out = 0;
     var note, envelope;
     envelope = Line.kr(0.1, 0.0, 1.0, doneAction: 2);
     note = SinOsc.ar(440, 0, envelope);
     Out.ar(out, note);
}).writeDefFile("/Users/gordonguthrie/.synthdefs"))
```

To use it in Sonic Pi we need to first load it and then just use it as normal

```ruby
load_synthdefs "/Users/gordonguthrie/.synthdefs"

use_synth(:myfirstsynth)

play 69
```

Play about with this. There are a couple of things to notice - the sound will always be coming from one side of the speakers. That's a bit odd. And also as you change the note up and down it makes no difference. It just plays A4 that fades out in 1 second.

We will fix both of these things later on. But first lets breakdown the synth definition:

```supercollider
/*
Define the synth - give it a name "myfirstsynth"
let it take one argument: `out`
*/

(SynthDef("myfirstsynth", {arg out = 0;

     // define 2 variables
     var note, envelope;

     /*
     Create a sound envelope that goes from 0.1 to 0 in 1 second
     and when it has done that trigger an action
     that destroys the running instance of
     the synthesiser and frees all memory
     */
     envelope = Line.kr(0.1, 0.0, 1.0, doneAction: 2);

     // define the note we are going to play A4 at 440Hz and set the volume to be the envelope
     note = SinOsc.ar(440, 0, envelope);

     // send the new note to the output channel 0
     Out.ar(out, note);
}).writeDefFile("/Users/gordonguthrie/.synthdefs"))
```

We have had to do a bit more work to get it to play nice with Sonic Pi. It has a few problems:

* it only plays one note (A4) - it needs to play any note
* it plays in the left speaker only - it needs to be in stereo
* each note is 1 second in duration - we need to be able to control how long a note lasts
* it only plays one note at a time - it needs to play chords - this is going to be a problem - see the section [Limitations](./#Limitations]

But its not all bad - the line that determines the length of the note also calls a self-destruct function that cleans up and frees resources - without it your computer would gradually fill up with unused instances of synthesisers consuming both memory and CPU and eventually would just crash.

## Next Steps

In Chapter 2 we will gradually build up this synthesiser until it is a clone of the `sine` synthesiser that is built into Sonic Pi.

We will add the following functions and defaults:

* `note` - default `52` - slideable
* `amp` - default `1` - slideable
* `pan` - default `0` - slideable
* `attack` - default `0`
* `decay` - default `0`
* `sustain` - default `0`
* `release` - default `1`
* `attack_level` - default `1`
* `decay_level` - default `attack_level`
* `sustain_level` - default `1`
* `env_curve` - default `2`

and the following slide options:

* `_slide`
* `_slide_shape`
* `_slide_curve`

## Limitations

Sonic Pi is designed to make it easy for users to write code. One of the ways it does this is by allowing functions to take multiple formats of their paramters.

The most obvious one is the note to play. The same command `play` will take either a single note or a list of notes as a paramater:

```ruby
use_synth :beep
play :A4
sleep 1
play [52, 55, 59]
sleep 1
play chord(:E3, :minor)
```

The minor chord of E in the 3rd octave is just a ring of of the notes ``52``, ``55`` and ``59``.

The chord function returns those notes wrapped in a ring data structure.

How does it do that? Well the synth `beep` is a built in synthesiser. In the file `synthinfo.rb` which is under `app/server/ruby/lib/sonicpi/synths/` in the source tree we find a defintion of what options it takes:

```ruby
class Beep < SonicPiSynth
      def name
        "Sine Wave"
      end

      def introduced
        Version.new(2,0,0)
      end

      def synth_name
        "beep"
      end

      def doc
        "A simple pure sine wave. The sine wave is the simplest, purest sound there is and is the fundamental building block of all noise. The mathematician Fourier demonstrated that any sound could be built out of a number of sine waves (the more complex the sound, the more sine waves needed). Have a play combining a number of sine waves to design your own sounds!"
      end

      def arg_defaults
        {
          :note => 52,
          :note_slide => 0,
          :note_slide_shape => 1,
          :note_slide_curve => 0,
          :amp => 1,
          :amp_slide => 0,
          :amp_slide_shape => 1,
          :amp_slide_curve => 0,
          :pan => 0,
          :pan_slide => 0,
          :pan_slide_shape => 1,
          :pan_slide_curve => 0,

          :attack => 0,
          :decay => 0,
          :sustain => 0,
          :release => 1,
          :attack_level => 1,
          :decay_level => :sustain_level,
          :sustain_level => 1,
          :env_curve => 2
        }
      end
    end
```

When you call `beep` Sonic Pi knows that it is a built in, and knows a whole lot of stuff about it, that it is built to a certain interface, that it exposes certain parameters, what the default values are and so on and so forth.

But when you load and compile your own synths the simple way, none of that information is available to Sonic Pi. So if you call your synth with a chord and not a note, Sonic Pi goes *"what contract does this synth support? I dunno. Can I safely monkey with the data? Nuh."* and boom.

```ruby
load_synthdefs "/Users/gordonguthrie/.synthdefs"

use_synth(:myfirstsynth)

play 69
```

There is a way around this, you can extend the set of built in synths by editing the source code and compiling your own customer version of Sonic Pi.

In this tutorial we will stick with writing limited synths that you can add simply to Sonic Pi.

If you are interested you can find where the munging happens in the file `sound.rb` under `app/server/ruby/lib/sonicpi/lang/` in the source tree:

```ruby
        if info
          # only munge around with :note and notes if
          # this is a built-in synth.
          notes = args_h[:notes] || args_h[:note]
          if is_list_like?(notes)
            args_h.delete(:notes)
            args_h.delete(:note)
            shifted_notes = notes.map {|n| normalise_transpose_and_tune_note_from_args(n, args_h)}
            return trigger_chord(synth_name, shifted_notes, args_h)
          end

          n = args_h[:note] || 52
          n = normalise_transpose_and_tune_note_from_args(n, args_h)

```


