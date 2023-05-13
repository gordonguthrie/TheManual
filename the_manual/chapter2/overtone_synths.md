# Chapter 2 - Existing synths in Sonic Pi

## The Clojure library: Overtone

For earlier versions of Sonic Pi synths were written not in SuperCollider but with a Clojure library called [Overtone](https://github.com/overtone/overtone).

Remember that FX and sample handling and anything that also affects sound is handled in SuperCollider under the covers and the source code that you find in the [Clojure synths](https://github.com/sonic-pi-net/sonic-pi/tree/710107fe22c5977b9fa5e83b71e30f847610e240/etc/synthdefs/designs/overtone/sonic-pi/src/sonic_pi) directory will include code to do that too.

The reason for this is that it is easier to incorporate Clojure source code into a multi-server compile and tooling chain - but harder to do the same with SuperCollider source which is designed to be saved and compiled inside the SuperCollider built in IDE.

`Sonic PI V5.0.0 Tech Preview 2` has some newer, more sophisticated synths written directly in SuperCollider.

To see how `Sonic PI V5.0.0 Tech Preview 2` handles the built in synths written in `overtone` let's look at the file [basic.clj](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/etc/synthdefs/designs/overtone/sonic-pi/src/sonic_pi/basic.clj)

If we scroll down to the [bottom](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/etc/synthdefs/designs/overtone/sonic-pi/src/sonic_pi/basic.clj#L945) we can see the synths being compiled:

```clojure
 (comment
   (core/save-synthdef sonic-pi-beep)
   (core/save-synthdef sonic-pi-saw)
   (core/save-synthdef sonic-pi-tri)
   (core/save-synthdef sonic-pi-pulse)
   (core/save-synthdef sonic-pi-subpulse)
   (core/save-synthdef sonic-pi-square)
   (core/save-synthdef sonic-pi-dsaw)
   ...
```
If we scroll back up to the [top](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/etc/synthdefs/designs/overtone/sonic-pi/src/sonic_pi/basic.clj#L19) we can find the definition of the `beep` synth in Clojure:

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

Lets have a look at this.

```clojure
defsynth sonic-pi-beep
```

This is obviously the opening of the SuperCollider code:

```supercollider
SynthDef("myfirstsynth"
```

The next bit is all the arguments the synth takes (with their defaults).

Then we hit the meat of the beast:

```clojure
   (let [decay_level (select:kr (= -1 decay_level) [decay_level sustain_level])
         note        (varlag note note_slide note_slide_curve 
   ...
```

If we go through this code we can see a lot of things that are clearly UGens and methods:

* `select` - the supercollider [Select UGen](https://doc.sccode.org/Classes/Select.html)
* `varlag` - the class [VarLag](https://doc.sccode.org/Classes/VarLag.html)
* `midicps` - the class [midicps](https://doc.sccode.org/Classes/AbstractFunction.html#-midicps)
* `sin-osc` - the [SinOsc UGen](https://doc.sccode.org/Classes/SinOsc.html)
* `env-gen` - the [EnvGen UGen](https://doc.sccode.org/Classes/EnvGen.html)
* `core/shaped-adsr` - an overtone library that generates an asdr envelope [asdr](https://doc.sccode.org/Classes/Env.html#*adsr) (we will have to do this manually)
* `out` - the [Out UGen](https://doc.sccode.org/Classes/Out.html)
* `pan` - one of the [Pan UGen](https://doc.sccode.org/Classes/Pan2.html) family
* `:action` - related to [doneAction](https://doc.sccode.org/Classes/SerialPort.html#-doneAction) somehow

We can also see that when a `uGen` offers a `.kr` and `.ar` option the clojure default is `.ar` and we have to specify `.kr` explicitly. This makes sense as we use `.ar` for sound signals (that we care a lot about) and `.kr` for control signals that we are a bit meh about.

This synth uses the uGen `SinOsc` to generate its output - just like the first synth in Chapter 1. This is the synth we will be recreating in Chapter 3.

If we look at our old first synth definition we can see some of these elements and how we have to compose them:

```supercollider
(SynthDef("myfirstsynth", {arg out_bus = 0;

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
     Out.ar(out_bus, note);
}).writeDefFile("/home/gordon/.synthdefs"))
```

So using the Overtone library we can transcribe a SuperCollider definition of a synthesizer into a Lisp format and then use a compiler against that to emit the appropriate compiled `SuperCollider` bytecode for Sonic Pi to use.

When we develop our own version of beep we will reverse engineer this Overtone description into SuperCollider code.
