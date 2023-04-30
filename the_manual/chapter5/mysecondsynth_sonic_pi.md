# Chapter 5 - Recreating the bep synth

## Where's my synth?

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

We can test that the synth is controllable in the usual way:

```ruby
```



