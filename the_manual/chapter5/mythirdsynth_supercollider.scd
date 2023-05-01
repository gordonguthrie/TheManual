/*

## Chapter 5 - Recreating the beep Synth

A simple beep synthesiser - third version

This synth accepts the following parameters:

* `note` a midi note
* `note_slide` the time in beats it takes for a note to change when controlling a synth (0 means a step change)
* `note_slide_shape` the shape of the transition of the note
* `note_slide_curve` for custom shapes whether the transition curves up or down
* `pan` a location to pan to (Sonic Pi should ensure it is between -1.0 and 1.0)
* `pan_slide` - like `note_slide` but for `pan`
* `pan_slide_shape` - like `note_slide_shape` but for `pan`
* `pan_slide_curve` - like `note_slide_curve` but for `pan`
* `amp` a volume
* `amp_slide` - like `note_slide` but for `amp`
* `amp_slide_shape` - like `note_slide_shape` but for `amp`
* `amp_slide_curve` - like `note_slide_curve` but for `amp`
* `sustain` the time the sound lasts - WATCH OUT! - see the 2nd synth for why this isn't `duration`
*/
(SynthDef('sonic-pi-mythirdsynth', {| out = 0,
									  note = 52.0, note_slide = 0, note_slide_shape = 1, note_slide_curve = 0,
									  pan = 0, pan_slide = 0, pan_slide_shape = 1, pan_slide_curve = 0,
									  amp = 1, amp_slide = 0, amp_slide_shape = 1, amp_slide_curve = 0,
									  sustain = 1|
	// define the variables that we will use later
    var snd, env, freq, slid_note, slid_amp, slid_pan;
	// set up an envelope that last as long as the sustain value
	env = Line.kr(0.1, 0.0, sustain, doneAction: 2);
	// slide the note
	slid_note = VarLag.kr(note, note_slide, note_slide_curve, note_slide_shape);
	slid_amp = VarLag.kr(amp, amp_slide, amp_slide_curve, amp_slide_shape);
	slid_pan = VarLag.kr(pan, pan_slide, pan_slide_curve, pan_slide_shape);
	// convert the midi note to frequency
	freq = midicps(slid_note);
	// get a beep from the Sin Oscillator and then place it in the Pan
	// and set the volume
	snd = Pan2.ar(SinOsc.ar(freq, 0, env), pos: slid_pan, level: slid_amp);
	// play
	Out.ar(out, snd)
}).writeDefFile("/home/gordon/.synthdefs"))
