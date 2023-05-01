# Chapter 5 - Recreating the beep synth

## Using the third version

We have added extra synth controls compared to version 2, so lets just test those out.

```ruby
use_synth(:mythirdsynth)

use_osc_logging true

play 65

sleep 1

s = play 69, duration: 12, note_slide: 0.2, note_slide_curve: 0.4, amp_slide: 0.4, amp_slide_shape: 4, pan_slide: 0.4, pan_slide_shape: 7

print(s)

sleep 1

control s, note: 72, amp: 0.7, pan: 0.3

sleep 1

control s, note: 72, amp: 0.5, pan: 0.37

sleep 1

control s, note: 69, amp: 0.85, pan: -0.35

sleep 1

control s, note: 75, amp: 0.4, pan: 0.8
```
If you get errors when you do this, go back and read the section on running Version 2 for tips.

Just like in version have to use `load_synthdefs` unless we actually save the synthdef to the correct boot directory - which is `etc/synthdefs/compiled`


