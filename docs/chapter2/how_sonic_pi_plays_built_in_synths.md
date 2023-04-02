# Chapter 2 - Existing synths in Sonic Pi

## How Sonic Pi plays built-in synths


Lets put some logging in and see what happens when we write simple synth command:

```ruby
use_synth :beep
play chord(:E3, :minor) , pan: -0.3, george: 44
```

The function [use_synth](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/lang/sound.rb#L867) sets the name of the synth into a shared memory area where it can be used later.

Then the function [play](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/lang/sound.rb#L1190) is called - it does some prepatory work on setting up the call to the synthesiers - in particular taking an unnamed first value `n` passed in that isn't a hash of anysort and tagging it as `{note: n}'.

It then calls the function [synth](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/lang/sound.rb#L1190). If the option to use external synths isn't checked and the synth isn't a built-in one it will crash out with an error here. If no synthesiser is specified in this call (which in our example there won't be) then the synth name is taken from the thread-shared storage that `use_synth` popped it into.

It takes the arguments passed in and call the function [resolve_synth_opts_hash_or_array](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/lang/sound.rb#L1190) which does the first munge - it looks at the data structure that is passed in andh checks it is an object that it can use, or it needs to be sanitised elsewhere. If this funcion is called wtih an `SPVector` it is sent off to [merge_synth_arg_maps_array](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/util.rb#L418) to fix up.





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



