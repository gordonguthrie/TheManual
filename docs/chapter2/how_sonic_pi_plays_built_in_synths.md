# Chapter 2 - How Synths Are Currently Defined And Invoked

In `Sonic PI V5.0.0 Tech Preview 2` code for built in synths is extended over a base clas called [BaseInfo](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/synths/synthinfo.rb#L16) in the file `synthinfo.rb`.

The class has a whole range of functions which must be overwritten in implementing a new synth> Some refer to the lifetime of the synth like `initialize`, `on_start` and `on_finish`, some are invoked at runtime like `munge_opts` and some relate to how the synth presents to Sonic Pi like `arg_doc` and `introduced`.

 
