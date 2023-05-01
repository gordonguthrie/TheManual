# Chapter 5 - Recreating the beep synth

## So I went to use the 2nd version and where's it gone?

If you have just restarted Sonic Pi after editing the Ruby and you look at the synth page our new synth isn't there:

![No synth](../images/chapter5/no_synth.png)

We can tell the class has loaded correctly tho. The default validations are being applied as we can see if we invoke the synth setting `pan` to an invalid value:

```ruby
load_synthdefs "/home/gordon/.synthdefs"

use_synth(:mysecondsynth)

play 69, pan: 3.0
```

Which crashes with the error:

```ruby
Runtime Error: [buffer 0, line 5] - Runtime Error
Thread death!
 Value of opt :pan must be a value between -1 and 1 inclusively, got 3.0.
```

If we do a full recompile we can now see that the GUI has been updated with our new synth:

![GUI after full recompile](../images/chapter5/recompiled_gui.png)

## Control that synth

We can test that the synth is controllable in the usual way:

```ruby
load_synthdefs "/home/gordon/.synthdefs"

use_synth(:mysecondsynth)

play 65

sleep 1

s = play 69, duration: 12

print(s)

sleep 1

control s, note: 72, amp: 0.7, pan: 0.3

sleep 1

control s, note: 72, amp: 0.5, pan: 0.37

sleep 1
```

We have to use `load_synthdefs` unless we actually save the synthdef to the correct boot directory - which is `etc/synthdefs/compiled `

## DANGER, DANGER, what's occurring?

The supercollider code has a `sustain` parameter, but the ruby we have added specifies a `duration` - what's going on?

If we study the logs we can see what has happened.

```
{run: 1, time: 0.0}
 └─ synth :mysecondsynth, {note: 65.0}
 
{run: 1, time: 1.0}
 ├─ synth :mysecondsynth, {note: 69.0, sustain: 12}
 └─ #<SonicPi::SynthNode @id=11, @name=sonic-pi-mysecondsynth @state=pending>
 
{run: 1, time: 2.0}
 └─ control node 11, {note: 72.0, amp: 0.7, pan: 0.3}
 
{run: 1, time: 3.0}
 └─ control node 11, {note: 72.0, amp: 0.5, pan: 0.37}
 
{run: 1, time: 4.0}
 └─ control node 11, {note: 69.0, amp: 0.85, pan: -0.35}
 
{run: 1, time: 5.0}
 └─ control node 11, {note: 75.0, amp: 0.4, pan: 0.8}
 
=> Completed run 1

=> All runs completed

=> Pausing SuperCollider Audio Server
```
In the default parameter munging process the `duration` has been turned into a `sustain` - this is going to be a well-behaved Sonic Pi synth.

BEWARE: The behaviour of the synthesiser will change between loading it as an external synth and compiling in support for it in ruby.
