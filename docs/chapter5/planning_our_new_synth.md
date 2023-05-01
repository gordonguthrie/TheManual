<!-- DO NOT EDIT - this file generated by the literate code reader -->
<!-- https://gordonguthrie.github.io/literatecodereader/ -->
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
* `core/shaped-adsr` - we have to manually create an asdr envelope in SuperCollider here
* `out` - the [Out UGen](https://doc.sccode.org/Classes/Out.html)
* `pan` - one of the [Pan UGen](https://doc.sccode.org/Classes/Pan2.html) family
* `:action` - is a [doneAction](https://doc.sccode.org/Classes/SerialPort.html#-doneAction)

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

There's some weird stuff tho. The `Overtone` definition has all the default arguments from the function `arg_defaults` baked in too, along with an outbus set to `0` (which just means play the sound on the computer). But a couple are different. In `Overtone` the `env_curve` default is `1` and the `decay_level` is -1` whereas in `arg_defaults` both are set to `1`.

***There are good reasons that default values are different in the Sonic Pi ruby and the SuperCollider code - read the example synth code in Chapter5 carefully to understand this***

## So whats the plan?

* `mysecondsynth` will use the `note` parameter and the `midicps` uGen to turn SonicPi midi notes into frequencies and let our synth play plain notes without a bend. It will also implement `amp` and `pan` (with the `Pan2` uGen) to let us control the volume and placing the sound on the left or right and `release` to determine the length of the note
* `mythirdsynth` will use the `VarLag` uGen to let us slide the `note`, `amp` and `pan` paramaters
* `myfourthsynth` will switch out from a `Line` envelope to a proper one using `env-gen` and take the `attack`, `decay`, `sustain` and `release` parameters - it will also use the `env_curve` to alter the shape of the envelope

Each of these synths will be implemented in both Sonic Pi and SuperCollider so they will have working error checking and can play chords.

For each synth we will look at:

* what needs to be written in SuperCollider
* what needs to be added in Sonic Pi (and where)
* what features are implemented when you play the synths

### Playing these synths

The synths in this manual are all written in literate SuperCollider - the code that generates the page you are reading is runnable in SuperCollider.

The Ruby parts you need to copy into Sonic Pi are also written in literate Ruby - so runnable Ruby code you can copy and paste.
