# Chapter 5 - Recreating the beep synth

## uGens, channels, mixing and panning

Before we can start making our simple synthesizer fit for use with Sonic Pi we need to learn a little about SuperCollider, in particular:

* uGens - Unit Generators
* Channels - how SuperCollider outputs sound signals
* Mixing - how we merge sound signals
* Panning - how we place sounds in the stereo field

## uGens

The code that we write for SuperCollider seems familiar, it seems like normal computer code, but it's not.

Most computer programmes work on `values`, SuperCollider works on `signals`.

If we set a variable to be 3 for instance:

```supercollider
a=3;
```

We can ask what value does `a` have and the answer is three.

What about setting a variable to the result of evaluation a `SinOsc`?

```supercollider
b={SinOsc(440 0, 0.2)};
```

What value does `b` have? Well it fluctuates between -1 and 1 440 times a second. `b` is not a variable like in `javascript` or `c` which holds discrete values, it holds a signal.

`SinOsc` is a `uGen` - a unit generator - a bit of code that generates a signal.

## Channels

Channels are just the software equivalent of the cables that you wire your stereo up with.

Maybe you have a fancy hifi setup on your flat screen at home with 5 speakers:

```
  ┌────────────────┐  ┌────────────────┐ ┌────────────────┐  ┌────────────────┐ ┌────────────────┐
  │                │  │                │ │                │  │                │ │                │
  │  Left Tweeter  │  │  Left Woofer   │ │    Sub Base    │  │  Right Woofer  │ │ Right Tweeter  │
  │                │  │                │ │                │  │                │ │                │
  └────────────────┘  └────────────────┘ └────────────────┘  └────────────────┘ └────────────────┘




                                                 You
```

If you want SuperCollider to use this you would need to have it generate 5 Channels of output:

```
                                         ╔════════════════╗
                                         ║                ║
                                         ║ Supercollider  ║
                                         ║                ║
                                         ╚════════════════╝
                                                  │
                                                  │
                                                  │
                                                  │
                                                  │
                                                  │
           ┌───────────────────┬──────────────────┼───────────────────┬──────────────────┐
           │                   │                  │                   │                  │
           │                   │                  │                   │                  │
           │                   │                  │                   │                  │
       Channel 2           Channel 0          Channel 4           Channel 1          Channel 3
           │                   │                  │                   │                  │
           │                   │                  │                   │                  │
           ▼                   ▼                  ▼                   ▼                  ▼
  ┌────────────────┐  ┌────────────────┐ ┌────────────────┐  ┌────────────────┐ ┌────────────────┐
  │                │  │                │ │                │  │                │ │                │
  │  Left Tweeter  │  │  Left Woofer   │ │    Sub Base    │  │  Right Woofer  │ │ Right Tweeter  │
  │                │  │                │ │                │  │                │ │                │
  └────────────────┘  └────────────────┘ └────────────────┘  └────────────────┘ └────────────────┘




                                                 You
```

Obviously SuperCollider doesn't know your setup - you have to tell it, so it organises outputs using a simple approach and lets you handle how you want to wire up its outputs to a physical system.

If we look at our simple synth again, we can diagram its action:

```
                    ┌────────────┐
                    │            │
   Input: 440  ────▶│   SinOsc   │────▶ Output: sine wave at 440Hz on Channel 0
                    │            │
                    └────────────┘
```

So what happens when we call that from Sonic Pi? Sonic Pi assumes you are on a computer and you have 2 speakers only, a left and a right, either on your computer, on your desktop or in your headphones or earphones. So when we play our simple synth in Sonic Pi, we are making a noise in a setup like this:

```
                   ╔════════════════╗
                   ║                ║
                   ║    Sonic Pi    ║
                   ║                ║
                   ╚════════════════╝
                            │
                            ▼
                   ╔════════════════╗
                   ║                ║
                   ║ Supercollider  ║
                   ║                ║
                   ╚════════════════╝
                            │
                            │
                            │
          ┌─────────────────┴────────────────────┐
          │                                      │
      Channel 0                              Channel 1
          │                                      │
          ▼                                      ▼
 ┌────────────────┐                     ┌────────────────┐
 │                │                     │                │
 │      Left      │                     │     Right      │
 │                │                     │                │
 └────────────────┘                     └────────────────┘


                           You

```

This is why our basic synth makes a sound in the left hand speaker only.

We have seen that the `SinOsc` `UGen` takes a frequency parameter and outputs on a single channel. Well if instead of one value we accept an array of frequencies we will get an array of channels:

```
                               ┌────────────┐      Output: sine waves:
                               │            │
  Input: [440, 880, 1320] ────▶│   SinOsc   │────▶[440Hz  on Channel 0,
                               │            │      880Hz  on Channel 1,
                               └────────────┘      1320Hz on Channel 2]
```

Because SuperCollider can't know your setup it just numbers the channels from 0. Its up to you to organise sending the signals to where they want to go.

So what happens if I have a 2 speaker setup, with Channel 0 on the left and Channel 1 on the right like in Sonic Pi? What happens to the noise on Channels 2 and up? They plop out of the back of your computer and make a little pile of discarded noise on the table.

The way we solve this problem is by `mixing`.

## The Mix uGen

`Mix` is a `uGen` that takes an array of channels in, adds the signals together and outputs them on a single channel:

```
   Channel 0────┐
                │
   Channel 1────┤    ╔════════════╗
                │    ║            ║
   Channel 2────┼───▶║    Mix     ║─────▶Channel 0
                     ║            ║
   Channel 3─ ─ ┤    ╚════════════╝

   Channel 4─ ─ ┘

```

Great, so now if we get our `SinOsc` to play a chord, we can mix all the beeps together and actually hear them all, as a single thing. But it's still in the left speaker only. Maybe we want it on the left, maybe on the right, maybe in the middle. (Now this is not how a well behaved Sonic Pi synth plays a chord - it sends each note to a clone of the same synth. In building our `beep` clone we won't be using `Mix` but it make sense for you to know the context in which `Pan` operates.)

We can use a `uGen` called `Pan` to do this.

## The Pan uGen

`Pan` is a `uGen` that takes a single channel input and splits it into two:

```
                 ╔════════════╗
                 ║            ║   ┌──▶Channel 0
  Channel 0─────▶║    Pan     ║───┤
                 ║            ║   └──▶Channel 1
                 ╚════════════╝
```

## Put it all together

So the first thing we have to do to get our synth ready is put all these things together:

```

                               ╔════════════╗      Output: sine waves:        ╔════════════╗
                               ║            ║                                 ║            ║
  Input: [440, 880, 1320] ────▶║   SinOsc   ║────▶[440Hz  on Channel 0, ─────▶║    Mix     ║──┐
                               ║            ║      880Hz  on Channel 1,       ║            ║  │
                               ╚════════════╝      1320Hz on Channel 2]       ╚════════════╝  │
                                                                                              │
                            ┌─────────────────────────────────────────────────────────────────┘
                            │
                            │
                            │
                            │     Add 440Hz, 880Hz and        ╔════════════╗
                            │       1320Hz together           ║            ║        Half the volume on Channel 0
                            └─▶                          ────▶║  Pan 0.0   ║───────▶
                                  Output on Channel 0         ║            ║        Half the volume on Channel 1
                                                              ╚════════════╝ 
```
