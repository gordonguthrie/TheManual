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
* it only plays one note at a time - it needs to play chords
* it plays in the left speaker only - it needs to be in stereo
* each note is 1 second in duration - we need to be able to control how long a note lasts

But its not all bad - the line that determines the length of the note also calls a self-destruct function that cleans up and frees resources - without it your computer would gradually fill up with unused instances of synthesisers consuming both memory and CPU and eventually would just crash.

In Chapter 3 we will gradually build up this synthesiser until it is a clone of the `sine` synthesiser that is built into Sonic Pi.

We will add the following functions and defaults:

* `note` - default `52` - slideable
* `amp` - default `1` - slideable
* `pan` - default `0` - slideable
* `attack`
* `decay` - default `0`
* `sustain` - default `0`
* `release` - default `1`
* `attack_level`
* `decay_level`
* `sustain_level`
* `sustain_level` - default `1`
* `env_curve` - default `2`

and the following slide options:

* `_slide`
* `_slide_shape`
* `_slide_curve`

But before we can build a proper synth we need to understand how Sonic Pi calls synthesiser - both built in and user added. Chapter 2 will cover that.
