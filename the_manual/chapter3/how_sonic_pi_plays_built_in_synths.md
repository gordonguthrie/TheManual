# Chapter 3 - Deep dive

## How Sonic Pi plays built-in synths


Lets put some logging in and see what happens when we write simple synth command:

```ruby
use_synth :beep
play chord(:E3, :minor) , pan: -0.3, george: 44
```

The function [use_synth](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/lang/sound.rb#L867) sets the name of the synth into a shared memory area where it can be used later.

Then the function [play](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/lang/sound.rb#L1190) is called - it does some preparatory work on setting up the call to the synthesisers - in particular taking an unnamed first value `n` passed in that isn't a hash of any sort and tagging it as `{note: n}`.

It then calls the function [synth](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/lang/sound.rb#L1190). If the option to use external synths isn't checked and the synth isn't a built-in one it will crash out with an error here. If no synthesiser is specified in this call (which in our example there won't be) then the synth name is taken from the thread-shared storage that `use_synth` popped it into.

`synth` does a call to `Synths::SynthInfo.get_info(sn_sym)` to pick up the information about the synth - this will be used later on.

It takes the arguments passed in and call the function [resolve_synth_opts_hash_or_array](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/lang/sound.rb#L1190) which does the first munge - it looks at the data structure that is passed in and checks it is an object that it can use, or it needs to be sanitised elsewhere. If this function is called with an `SPVector` it is sent off to [merge_synth_arg_maps_array](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/util.rb#L418) to fix up.





In `Sonic PI V5.0.0 Tech Preview 2` code for built in synths is extended over a base class called [BaseInfo](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/synths/synthinfo.rb#L16) in the file `synthinfo.rb`.

The class has a whole range of functions which must be overwritten in implementing a new synth. Some refer to the lifetime of the synth like `initialize`, `on_start` and `on_finish`, some are invoked at runtime like `munge_opts` and some relate to how the synth presents to Sonic Pi like `arg_doc` and `introduced`.



We can see how Sonic Pi [handles synth arguments](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/lang/sound.rb#L3753) in this function.

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


