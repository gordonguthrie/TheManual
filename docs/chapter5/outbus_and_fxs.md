<!-- DO NOT EDIT - this file generated by the literate code reader -->
<!-- https://gordonguthrie.github.io/literatecodereader/ -->
# Chapter 5 - Recreating the beep synth

## The out_bus and FXs

In our first synth we had an `out_bus` parameter passed in and passed to the `Out` uGen. It's time to understand what it does.

Previously in the chapter on mixing and panning we saw that we can create many channels of sound - to get stereo we create two - and these channels need to be connected to our physical speakers.

A bus is just a collection of channels - and by default the SuperCollider bus `0` is connected to the default output channels of the computer (as defined in the settings). So either the computer built in speakers, or your headphone or your bluetooth bar and boom box. Which is what you would expect - we want noises to be played.

The question then is: why do we pass in the bus no, why don't we just hard code it? And the answer is FXs.

Let's play a beep:

```
play 69, pan: 0
```

The bus is wired up like this:

```
            ╔════════════════╗
            ║                ║
            ║    Sonic Pi    ║
            ║                ║
            ╚════════════════╝
                     │
                     ▼
            ╔════════════════╗
            ║ Supercollider  ║
            ║     Synth      ║
            ║                ║
            ╚════════════════╝
                     │
                   Bus 0
          ┌──────────┴──────────┐
          │                     │
          ▼                     ▼
 ┌────────────────┐    ┌────────────────┐
 │                │    │                │
 │  Left Speaker  │    │ Right Speaker  │
 │                │    │                │
 └────────────────┘    └────────────────┘
 ```

 Sonic Pi passes in an `out_bus` value of `0` and jobs a good 'un.

 When you wrap a synth (or sample) in FXs Sonic Pi needs to disconnect the synth from your speakers, patch it into the FX or FXs and then patch it back - and busses are how it does it:

 ```ruby
 with_fx :reverb do
  play 60, out_bus: 3
end
```

Sonic Pi creates a new Reverb FX with an input on bus `1` and out an output on bus `0` and then calls the synth passing in a value of `1` as the `out_bas` parameter:

```
            ╔════════════════╗
            ║                ║
            ║    Sonic Pi    ║
            ║                ║
            ╚════════════════╝
                     │
                     │
                     ▼
            ╔════════════════╗
            ║ Supercollider  ║
            ║     Synth      ║
            ║                ║
            ╚════════════════╝
                     │
                   Bus 1
                     ▼
            ╔════════════════╗
            ║                ║
            ║Supercollider FX║
            ║                ║
            ╚════════════════╝
                     │
                   Bus 0
          ┌──────────┴──────────┐
          │                     │
          ▼                     ▼
 ┌────────────────┐    ┌────────────────┐
 │                │    │                │
 │  Left Speaker  │    │ Right Speaker  │
 │                │    │                │
 └────────────────┘    └────────────────┘
```
