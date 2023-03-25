# Chapter 1 - First beeps

## First beep in SuperCollider

Most of the synths you are used to calling in Sonic Pi are implemented in Super Collider.

This tutorial is to enable you to write your own synths and for you, or other people, to use them in Sonic Pi.

Obviously if you can write Super Collider code you could just programme Super Collider without Sonic Pi. And this manual will help you learn some, but not all, of how to do just that.

Like Sonic Pi this manual has an overriding design principle - to get from nothing to make a noise as quickly as possible.

With Sonic Pi that's just:

```ruby
play :beep 69
```

With Super Collider it is nearly as fast.

Lets have a go.

To start with you need to tell the SuperCollider App to start the server engine.

This can be done with the menu item: `Server -> Boot Server`

You then need to check the log window to see if there are error messages. Sometimes you will need to edit audio settings on your machine to get SuperCollider to work.

The Super Collider version of `play :beep 69` is:

```supercollider
{SinOsc.ar(440, 0, 0.2)}.play;
```

Copy the snippet into the coding window on SuperCollider. Place the cursor in the code line and press `[SHIFT][ENTER]` and you will hear an `A4` note (the Stuttgart pitch for standard tuning).

This will play ***forever***.

To stop it you press `[COMMAND][.]` (the command key and the full stop at the same time.

One of the key differences between Super Collider and Sonic Pi is that Sonic Pi is sound-based (play this sound for this time period) and Super Collider is state-based - get this synthesiser into this state. By default sounds in Super Collider are of indefinite duration.

Lets break down that beep:

Its a function:

```supercollider
{ ... }
```

We are invoking the play method with the function:

```supercollider
{ ...}.play;
```

and the body of the function is a Sine Oscillator:

```supercollider
{SinOsc.ar(440, 0, 0.2)}.play;
```

`SinOsc` is an object, a sine wave oscillator.

`ar` is a method called on that object with the parameters `440`, `0` and `0.2`.

If we look up `SinOsc` in the documentation browser we will see that the object exposes two functions with the same signature:

```supercollider
SinOsc.ar(freq: 440.0, phase: 0.0, mul: 1.0, add: 0.0)
SinOsc.kr(freq: 440.0, phase: 0.0, mul: 1.0, add: 0.0)
```

We can see that the parameters in our invocation are:

* `440` - the frequency, corresponding to the note A4
* `0` - the phase
* `0.2` - the `mul` (or multiplier)

In this instance the `mul` is effectively the volume, make it higher and the note will sound lounder, lower it will be quieter.

Lets look again at the interface and the two methods `ar` and `kr`. The `ar`/`kr` pairing appears throughout SuperCollider so its important to understand what they mean.

* `ar` means **audio rate**
* `kr` means **control rate**

For the moment we will stick to `ar`. Later on when we start building a proper synthesiser for Sonic Pi we will look again at the meaning of these.


