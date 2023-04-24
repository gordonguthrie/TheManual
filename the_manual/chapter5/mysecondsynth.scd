/*

## Chapter 5 - Recreating the beep Synth

A simple beep synthesiser

This synth accepts the following parameters:

* `note` a midi note
* `amp` a volume (0.0 to 1.0)
* `pan` a location to pan to (between -1.0 and 1.0)
*/
(SynthDef("mysecondsynth", {arg out = 0, note = 52.0, amp = 1, pan = 0;
     // define the variables that we will use later
    var snd, env, freq;
     // convert the midi note to frequency
     freq = midicps(note);
     // set up an envelope that kills the sound after 1 second
     env = Line.kr(0.1, 0.0, 1.0, doneAction: 2);
     // get a beep from the Sin Oscillator and then place it in the Pan
     // and set the volume
     snd = Pan2.ar(SinOsc.ar(note, 0, env), pos: pan, level: amp);
     // play
     Out.ar(out, snd)
}).writeDefFile("/Users/gordonguthrie/.synthdefs"))