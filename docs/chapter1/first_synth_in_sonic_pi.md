# Chapter 1

## First Synth In Sonic Pi

We will make this oscillator into a synthesiser that we can use in Sonic Pi:

```supercollider
{SinOsc.ar(440, 0, 0.2)}.play;
```

There are somethings we will have to do to make it usable:

* it will need to turn off and not play endlessly. Sonic Pi expects notes to have a duration
* we will need to be able to pass the note in so it will play different notes
     * Sonic Pi expresses notes in terms of the midi note table, so `A4` not `440hz` - the synth will need to be able to accept Sonic Pi notes in and convert them into frequencies on the way out
* we will want to be able to make the note louder or quieter

First up lets convert this function into on that is callable:

```supercollider
f={SinOsc.ar(440, 0, 0.2)};
```

This defines the variable `synth` as our function. (You need to put the cursor on the line and do `[SHIFT][ENTER]` to invoke it.)

Once you have set the variable you can now call `play` on it:

```supercollider
f.play;
```

And remember `[COMMAND][.]` to stop it.


