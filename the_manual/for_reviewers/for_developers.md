# For Reviewers

## If you are an experienced Sonic Pi or SuperCollider developer

I need your help to improve quality:

* I haven't written any Ruby for 20 years so my knowledge is flaky
* I have been writing SuperCollider for about 3 months on and off and I really do know *hee-haw McGraw, his Maw and Pa anaw* about it, so don't be shy about telling me where I get it wrong

There are some aspects that I still don't know but would like to, so I can finish this damn manual off and get on with writing my own synths:

* some parameters can be changed with `control` and some can't. What are the mechanics of that? Is it something Sonic Pi does or SuperCollider?
* how can I get debuggin information out of SuperCollider to investigate what is happening at runtime - I can't seem to work it out
* how can I get a trace of a dump of OSC commands between the Sonic Pi server and the running SuperCollider instance? setting `use_osc_logging` to `true` only gives me error messages.
* can I pass arrays to my new synth, or is it only values? and is that a limitation of the Sonic Pi implementation or OSC or what?
* how does BPM management work - I pass in beat-length values for `attack`, `sustain`, `decay`, `release` but they magically change in reality with changes of BPM - I presume that Sonic Pi manages some global BPM value for SuperCollider?

```

  _    _       _       _ 
 | |  | |     | |     | |
 | |__| | __ _| |_ __ | |
 |  __  |/ _` | | '_ \| |
 | |  | | (_| | | |_) |_|
 |_|  |_|\__,_|_| .__/(_)
                | |      
                |_|      

```

Also I am not sure if my fourth synthesiser is working correctly but I am struggling to debug it.
