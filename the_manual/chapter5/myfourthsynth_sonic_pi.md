# Chapter 5 - Recreating the beep synth

## Using the fourth version

We have added extra synth controls compared to version 3, so lets just test those out.

```ruby
load_synthdefs "/Users/gordonguthrie/.synthdefs"

use_synth(:myfourthsynth)

play 54, pan: 0.9, amp: 0.4, attack: 1, decay: 0.5, sustain: 3

sleep 0.5

play 58, pan: -0.3, amp: 0.7

sleep 0.5

play 92, pan: 0.3, amp: 1.0
```
If you get errors when you do this, go back and read the section on running Version 2 for tips.

Just like in version have to use `load_synthdefs` unless we actually save the synthdef to the correct boot directory - which is `etc/synthdefs/compiled`


