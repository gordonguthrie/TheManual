/*

## Chapter 5 - Recreating the beep Synth

A simple beep synthesiser - fourth and final version in SuperCollider

This synth accepts the following parameters:

* `note` a midi note
* `note_slide` the time in beats it takes for a note to change when controlling a synth (0 means a step change)
* `note_slide_shape` the shape of the transition of the note
* `note_slide_curve` for custom shapes whether the transition curves up or down
* `pan` a location to pan to (between -1.0 and 1.0)
* `pan_slide` - like `note_slide` but for `pan`
* `pan_slide_shape` - like `note_slide_shape` but for `pan`
* `pan_slide_curve` - like `note_slide_curve` but for `pan`
* `amp` a volume (0.0 to 1.0)
* `amp_slide` - like `note_slide` but for `amp`
* `amp_slide_shape` - like `note_slide_shape` but for `amp`
* `amp_slide_curve` - like `note_slide_curve` but for `amp`
* `attack` amount of time for sound to build up to full amplitude
* `decay` amount of time for sound to move from the attack to the sustain level
* `sustain` amount of time the sound is sustained
* `release` amount of time for sound to go from the sustained level to 0
* `attack_level` sound level at attack phase
* `decay_level` sound level in decay phase
* `sustain_level` sound level in sustain phase
* `env_curve` shape of the curve of volume transition
*
* the default value of `decay_level` is -1 even tho the only valid values of `decay_level`
* that Sonic Pi will ever accept are a greater than zero - this is used to test if a `decay_level` has been set
*/
(SynthDef("sonic-pi-myfourthsynth", {| out = 0,
	                        note = 52.0, note_slide = 0, note_slide_shape = 1, note_slide_curve = 0,
	                        amp = 1, amp_slide = 0, amp_slide_shape = 1, amp_slide_curve = 0,
	                        pan = 0, pan_slide = 0, pan_slide_shape = 1, pan_slide_curve = 0,
	                        attack = 0, decay = 0, sustain = 0, release = 1,
	                        attack_level = 1, decay_level = -1, sustain_level = 1,
	                        env_curve = 1 |
	// define the variables that we will use later
    var snd, env, freq, slid_note, slid_amp, slid_pan;
	// use the Select uGen and the invalid default value to make the `decay_level` be the 
	// same as the `sustain_level` if no `decay_level` is set
	// if the `decay_level` isn't minus one - use the zeroth member of the index, itself
	// otherwise use the first member - the `sustain_level`
	decay_level = Select.kr(if((decay_level != -1), 0, 1), [decay_level, sustain_level]);
	// Create an envelope with the full attack, decay, sustain, release shape
	// NOTE: there are 5 levels, but only 4 times and curves - the levels are the start and end of each section
	//       the times and curves are the section itself - in this synth the curve is the same for all elements
	env = EnvGen.kr(Env.new(levels: [0, attack_level, decay_level, sustain_level, 0],
		                    times:  [attack, decay, sustain, release], 
		                    curve:  Array.fill(4, env_curve)), doneAction: 2);
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
