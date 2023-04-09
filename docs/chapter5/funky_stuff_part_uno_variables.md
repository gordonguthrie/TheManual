# Chapter 5 - Recreating the beep synth

## Funky stuff part uno - variables

In the last section we started by creating a named function and calling it:

```supercollider
f={SinOsc.ar(440, 0, 0.2)};

f.play;
```

The name we chose was `f`. Try and replace that with a better name like `my_synth`.

Oops it doesn't work.

SuperCollider has 3 types of variable name:

* one letter global variables like `f`
* long global variables that begin with a tilda - like `~my_synth`
* local variables that are multi-letter like `mysynth`

By convention the letter `s` is used to control the local server:

```supercollider
s=Server.local;

s.boot;

s.quit;
```
