# Chapter 3 - Deep dive

## How Sonic Pi plays synths

Lets put some logging in and see what happens when we write a simple synth command:

```ruby
use_synth :beep
play chord(:E3, :minor) , pan: -0.3, george: 44
```

### use_synth function in sound.rb

The function [use_synth](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/lang/sound.rb#L867) sets the name of the synth into a shared memory area where it can be used later.

### play function in sound.rb

Then the function [play](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/lang/sound.rb#L1190) is called - it does some preparatory work on setting up the call to the synthesisers - in particular taking an unnamed first value `n` passed in that isn't a hash of any sort and tagging it as `{note: n}`.

### synth function in sound.rb

It then calls the function [synth](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/lang/sound.rb#L1064). If the option to use external synths isn't checked and the synth isn't a built-in one it will crash out with an error here. If no synthesiser is specified in this call (which in our example there won't be) then the synth name is taken from the thread-shared storage that `use_synth` popped it into.

`synth` does a call to `Synths::SynthInfo.get_info(sn_sym)` to pick up the information about the synth - this will be used later on.

***This is the critical part for the difference between handling built-in synths and user-defined ones***. If the call to `get_info` returns `nil` then SonicPi knows that its not a built-in synth and will simply not try and use the validation that comes with built-in synths.

In `Sonic PI V5.0.0 Tech Preview 2` code for built in synths is extended over a base class called [BaseInfo](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/synths/synthinfo.rb#L16) in the file `synthinfo.rb`.

The class has a whole range of functions which must be overwritten in implementing a new synth. Some refer to the lifetime of the synth like `initialize`, `on_start` and `on_finish`, some are invoked at runtime like `munge_opts` and some relate to how the synth presents to Sonic Pi like `arg_doc` and `introduced`.

The functions in `synthinfo.rb` and its role in defining the behaviour of Sonic Pi will be covered extensively in *Chapter 4 - the world of built-in synths*.

`synth` takes the arguments passed in and call the external utility function [resolve_synth_opts_hash_or_array](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/util.rb#L347) which does the first munge - it looks at the data structure that is passed in and checks it is an object that it can use, or it needs to be sanitised elsewhere. If this function is called with an `SPVector` it is sent off to [merge_synth_arg_maps_array](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/util.rb#L418) to fix up.

Next `synth` checks if the note is a rest note - and if it does it returns nothing.

 Now we start getting to where built-in and user-defined synths are treated differently.

 `synth` checks if the synth info is `nil` - if it isn't it then knows that this is a built-in synth and is well behaved.

 There are a number of global settings that can be applied to code blocks to change the notes being played:

 * `use_cent_tuning`/`with_cent_tuning`
 * `use_octave`/`with_octave`
 * `use_transpose`/`with_transpose`

If the synth is well behaved these global settings will be applied in [normalise_transpose_and_tune_note_from_args](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/util.rb#L4052).

Earlier we looked at error messages and saw that you could play chords with built-in synths but not with user-defined ones.

Playing chords requires a transform which is only done for built-in functions.

A call to a built-in synth may (if it is a chord) be passed onto the function [trigger_chord](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/lang/sound.rb#L3475) but if it is a user-defined one it will always be passed to [trigger_inst](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/lang/sound.rb#L3452).

### trigger_chord function in sound.rb

***Nota Bene/Take Note***: the function `trigger_chord` ***DOESN'T*** call the synth in SuperCollider and pass it a chord - it asks SuperCollider to play each note separately.

![Chords as notes](../images/uml/play_chord.png)

IT does some housekeeping - including calling [normalise_and_resolve_synth_args](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/lang/sound.rb#L3753) - to make sure that SuperCollider behaves well - the synth that plays each note is grouped, the volume of each note is normalised - the volume of each note is divided by the number of the notes so that the chord as a whole sounds as loud as the specified volume.

`trigger_chord` ends up calling [trigger_synth](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/lang/sound.rb#L3525).

### trigger_inst function in sound.rb

`trigger_inst` does a little housekeeping - including calling [normalise_and_resolve_synth_args](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/lang/sound.rb#L3753) and possibly tweaking the slide times in [add_arg_slide_times](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/lang/sound.rb#L4032) - before moving on to calling  [trigger_synth](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/lang/sound.rb#L3525).


### normalise_and_resolve_synth_args function in sound.rb

Lets look at how Sonic Pi [handles synth arguments](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/lang/sound.rb#L3753) in some more details. Here is the function:

```ruby
      def normalise_and_resolve_synth_args(args_h, info, combine_tls=false)
        purge_nil_vals!(args_h)
        defaults = info ? info.arg_defaults : {}
        if combine_tls
          t_l_args = __thread_locals.get(:sonic_pi_mod_sound_synth_defaults) || {}
          t_l_args.each do |k, v|
            args_h[k] = v unless args_h.has_key? k || v.nil?
          end
        end
```

This block handles the use of synth defaults and we can see if it we run code like this in Sonic Pi:

```ruby
use_synth_defaults amp: 0.5, pan: -1

play 50
```

In this case the synth defaults are stashed and retrieved by the call to `get` the `:sonic_pi_mod_sound_synth_defaults` setting `t_l_args` to `(map amp: 0.5, pan: -1)`.

The function `normalise_args!` later on turns options like `bpm_scale` which take `true` or `false` as options into numerical arguments - so `1.0` and `0.0`.

If we pass in a `duration` by calling this code:

```ruby
play note: 44, duration: 0.3, pan: -0.3, george: 44
```

when we log the transform we see that a sustain has been added by the function `calculate_sustain!`:

```
synth :beep, {note: 44.0, pan: -0.3, george: 44, sustain: 0.3}
```

at the end of `normalise_and_resolve_synth_args` all the user supplied arguments have been tidied up and made coherent.

If we try the same thing with our custom synth we see that these transforms have also been made:

```ruby
use_synth :myfirstsynth
play note: 44, duration: 0.3, pan: -0.3, george: 44
```

is transformed to:

```
synth :myfirstsynth, {note: 44.0, pan: -0.3, george: 44, sustain: 0.3}
```

### trigger_synth function in sound.rb

This function actually makes the sound happen - but before it does that it does validation of the arguments in [validate_if_necessary!](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/lang/sound.rb#L3908)

This call to `validate_if_necessary!` is the end of our deep dive. This function takes the current synth object from all the way back up in the call to `play` and asks it to validate itself.

If the synth is built-in, it calls its validator function and borks if the parameters are invalid. If the synth is user-defined there is no validator and the parameters are sent across to SuperCollider as-is.

## What you need and don't need to know to write your own synth

You don't need to know anything of this chapter to write your own well-behaved synthesiser - to write a badly-behaved one, this spelunk should get you started.
