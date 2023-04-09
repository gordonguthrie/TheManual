# Chapter 5 - Recreating the beep synth

## Why does this matter?

The code for synthesisers is pretty confusing. Good documentation is key to understanding how they are built and why. This chapter lays the ground work for understanding our documentation going forward.

## Moar UGen Stuff

Generally we can diagram a `UGen` like this:

```
                       Monkey           Monkey           Monkey
                       about 1          about 2          about 3
                          │                │                │
                          │                │
                          │                │                │
                          │                │
                          │                │                │
 Signal 0 in──────┐       ▼                ▼                ▼     ┌────▶Signal 0 out
                  │       ┌─────────────────────────────────┐     │
 Signal 1 in──────┤       │                                 │     ├────▶Signal 1 out
                  │       │                                 │     │
 Signal 2 in──────┼──────▶│              UGen               │─────┘─ ─ ▶Signal 2 out
                          │                                 │     │
 Signal 3 in─ ─ ─ ┤       │                                 │      ─ ─ ▶Signal 3 out
                          └─────────────────────────────────┘     │
 Signal 4 in─ ─ ─ ┘                                                ─ ─ ▶Signal 4 out

```

We take a set of audio signals in, we monkey with them based on parameters we pass in and we pass a set of signals out. Usually the signals are audio signals, but they can be controls.

Previously it seemed we had two different constructs:

```supercollider
a=3;
b={SinOsc(440, 0.1, 1)};
```

Where `a` is a constant and `b` is a signal. Reading SuperCollider code it often seems like these are different things, parameters and streams. In fact `a` is a constant signal, not a discrete constant. Anywhere you see numbers passed in, as volume parameters, as panning parameters to place sounds in the stereo field, you can also pass in variable streams.

Sonic Pi uses this to control synths:

```ruby
s = play 60, release: 5
sleep 0.5
control s, note: 65
sleep 0.5
control s, note: 67
sleep 3
control s, note: 72
```

Here we have started a synth and passed in a constant stream of 60 as the note value. Then we change the value of the stream to 65, then 67 and then 72.

## .kr and .ar

We saw earlier that `SinOsc` has two output modes:

* `.ar` or audio rate
* `.kr` or control rate

We know understand a bit better what that means. `audio rate` means the stream is fine grained and of high enough quality that it can be used to generate sounds (think representing an analog sound wave by a digital signal that goes up and down in tiny steps - the `.ar` is 44,100 steps per second.). `control rate` is a lower quality, less fine grained signal that is good enough for controls (think turning volumes up or down in big-ish steps - the `.kr` is 1/64th of the `.ar` or 690 steps per second).

`.ar` signals are 64 times as expensive to calculate than `.kr` ones. You can use `.ar` for everything (including controls) but best practice is not to.

With this understanding of `.kr` and `.ar` we see that there are two main `UGen` configurations - ones for manipulating sounds:

```
                                         │
                                         │
                                        .kr
                                  (control rate)
                                         │
                                         ▼
                        ┌─────────────────────────────────┐
                        │                                 │
           .ar          │                                 │             .ar
 ─────(audio input)────▶│              UGen               │────────(audio output)───────▶
                        │                                 │
                        │                                 │
                        └─────────────────────────────────┘

```

and ones for preparing control signals:

```
                                         │
                                         │
                                        .kr
                                  (control rate)
                                         │
                                         ▼
                        ┌─────────────────────────────────┐
                        │                                 │
           .kr          │                                 │             .kr
 ───(control output)───▶│              UGen               │───────(control output)──────▶
                        │                                 │
                        │                                 │
                        └─────────────────────────────────┘
```

(Sometimes you might want to use an audio signal both in sound processing and in controlling another `UGen` so don't obsess about this.)

## Hidden Ugens - + and *

There are a couple of hidden `Ugens` in Supercollider code - our old friends `*` and `+`.

```
                           ┌─────────────────────────────────┐
                           │                                 │
 Signal 0 in───────┐       │   * is a UGen that multiplies   │
                   ├──────▶│      two signals together       │──────────▶Signal 0 out
 Signal 1 in───────┘       │                                 │
                           │                                 │
                           └─────────────────────────────────┘
```

```
                           ┌─────────────────────────────────┐
                           │                                 │
 Signal 0 in───────┐       │      + is a UGen that adds      │
                   ├──────▶│      two signals together       │──────────▶Signal 0 out
 Signal 1 in───────┘       │                                 │
                           │                                 │
                           └─────────────────────────────────┘
```

