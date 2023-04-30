/*

## Chapter 5 - Recreating the beep Synth

A simple beep synthesiser - 2nd version

This synth accepts the following parameters:

* `note` a midi note
* `amp` a volume
* `pan` a location to pan to
* `release` the time the sound lasts
*/
(SynthDef("mysecondsynth", {arg out = 0, note = 52.0, amp = 1, pan = 0, release = 1;
     // define the variables that we will use later
     var snd, env, freq;
     // convert the midi note to frequency
     freq = midicps(note);
     // set up an envelope that kills the sound after 1 second
     env = Line.kr(0.1, 0.0, release, doneAction: 2);
     // get a beep from the Sin Oscillator and then place it in the Pan
     // and set the volume
     snd = Pan2.ar(SinOsc.ar(freq, 0, env), pos: pan, level: amp);
     // play
     Out.ar(out, snd)
}).writeDefFile("/Users/gordonguthrie/.synthdefs"))
