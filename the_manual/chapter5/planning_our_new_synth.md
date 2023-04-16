# Chapter 5 - Recreating the beep synth

## Planning our new synth

By inspecting the `Overtone` source in Chapter 2 we know what components we need to use to rebuild our own version of `beep`:

```clojure
(without-namespace-in-synthdef
 (defsynth sonic-pi-beep [note 52
                          note_slide 0
                          note_slide_shape 1
                          note_slide_curve 0
                          amp 1
                          amp_slide 0
                          amp_slide_shape 1
                          amp_slide_curve 0
                          pan 0
                          pan_slide 0
                          pan_slide_shape 1
                          pan_slide_curve 0
                          attack 0
                          decay 0
                          sustain 0
                          release 1
                          attack_level 1
                          decay_level -1
                          sustain_level 1
                          env_curve 1
                          out_bus 0]
   (let [decay_level (select:kr (= -1 decay_level) [decay_level sustain_level])
         note        (varlag note note_slide note_slide_curve note_slide_shape)
         amp         (varlag amp amp_slide amp_slide_curve amp_slide_shape)
         amp-fudge   1
         pan         (varlag pan pan_slide pan_slide_curve pan_slide_shape)
         freq        (midicps note)
         snd         (sin-osc freq)
         env         (env-gen:kr (core/shaped-adsr attack decay sustain release attack_level decay_level sustain_level env_curve) :action FREE)]
     (out out_bus (pan2 (* amp-fudge env snd) pan amp))))
```

* `select` - the supercollider [Select UGen](https://doc.sccode.org/Classes/Select.html)
* `varlag` - the class [VarLag](https://doc.sccode.org/Classes/VarLag.html)
* `midicps` - the class [midicps](https://doc.sccode.org/Classes/AbstractFunction.html#-midicps)
* `sin-osc` - the [SinOsc UGen](https://doc.sccode.org/Classes/SinOsc.html)
* `env-gen` - the [EnvGen UGen](https://doc.sccode.org/Classes/EnvGen.html)
* `core/shaped-adsr` - something that invokes [asdr](https://doc.sccode.org/Classes/Env.html#*adsr) somehow
* `out` - the [Out UGen](https://doc.sccode.org/Classes/Out.html)
* `pan` - one of the [Pan UGen](https://doc.sccode.org/Classes/Pan2.html) family
* `:action` - related to [doneAction](https://doc.sccode.org/Classes/SerialPort.html#-doneAction) somehow

This was our first attempt in Chapter 1:

```supercollider
(SynthDef("myfirstsynth", {arg out = 0;
     var note, envelope;
     envelope = Line.kr(0.1, 0.0, 1.0, doneAction: 2);
     note = SinOsc.ar(440, 0, envelope);
     Out.ar(out, note);
}).writeDefFile("/Users/gordonguthrie/.synthdefs"))
```

So there are some things we can see that overlap with the `Overtone` description.

In both the source of sound is a Sine Oscillator the uGen `SinOsc`, and the sound is patched to the speakers using the `Out` uGen.

Our synth uses a `doneAction: 2` and `Overtone` has an `:action: FREE` to destroy the synth and free up its resource.

Our synth has use the `Line` uGen whereas the `Overtone` one uses `EnvGen` - the fact that our `Line` uGen is bound to a variable called `envelope` does give the game away a bit here - our synth plays a constant volume, but `beep` has an envelope with `attack`, `decay`, `sustain` and `release`.

There's some wierd stuff tho. The `Overtone` definition has all the default arguments from the function `arg_defaults` baked in too, along with an outbus set to `0` (which just means play the sound on the computer). But a couple are different. In `Overtone` the `env_curve` default is `1` and the `sustain_level` is -` whereas in `arg_defaults` both are set to `1`.

***This is just belt and braces tho, when the synth is written in SuperCollider it makes sense to bake in the default values as you develop it, you will be writing, running and debugging the code in SuperCollider and will want to know what it sounds like when its played in SonicPi. In theory you could then copy the defaults to your*** `arg_default` ***function and delete them in your SuperCollider synth defintion. But why bother?***

## So whats the plan?

* `mysecondsynth` will use the `note` parameter and the `midicps` uGen to turn SonicPi midi notes into frequenies and let our synth play plain notes without a bend
* `mythirdsynth` will use the `amp` and `pan` parameters with the `Pan` uGen to add volume and panning control
* `myfourthsynth` will switch out from a `Line` envelope to a proper one using `env-gen` and take the `attack`, `decay`, `sustain` and `release` parameters - it will also use the `env_curve` to alter the shape of the envelope
* `myfifthsynth` will use `varlag` to add the sliding behaviour to `note`, `pan` and `amp`

In between these synths we will look at elements of the SuperCollider language.

***This manual will not teach you SuperCollider - just enough to get a Sonic Pi synth up from scratch.***

### Playing these synths

The synths in this manual are all written in literate SuperCollider - the code that generates the page you are reading is runnable in SuperCollider.
