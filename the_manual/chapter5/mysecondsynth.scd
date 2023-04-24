/*

## Chapter 5 - Recreating the beep Synth

A simple beep synthesiser

This synth accepts the following parameters:

* `note` a midi note
* `pan` a location to pan to (between -1.0 and 1.0)
* `amp` a volume (0.0 to 1.0)
*/
(SynthDef("mysecondsynth", {arg out = 0, note = 52.0, pan = 0, amp = 1;
     // define the variables that we will use later
    var sound, envelope, freq;
     // convert the midi note to frequency
     freq = midicps(note);
     // set up an envelope that kills the sound after 1 second
     envelope = Line.kr(0.1, 0.0, 1.0, doneAction: 2);
     // get a beep from the Sin Oscillator and then place it in the Pan
     // and set the volume
     sound = Pan2.ar(SinOsc.ar(440, 0, envelope), pos: pan, level: amp);
     // play
     Out.ar(out, sound)
}).writeDefFile("/Users/gordonguthrie/.synthdefs"))