# The Manual - Writing Super Collider Synthesisers For Sonic Pi

This is a manual about learning to write Super Collider synthesisers for use in Sonic Pi.

All the synths you are used to calling in Sonic Pi are implemented in Super Collider (actually the legacy ones are implemented in a different one.

This tutorial is to enable you to write your own synths and for you, or other people, to use them in Sonic Pi.

Obviously if you can write Super Collider code you could just programme Super Collider without Sonic Pi. And this manual will help you learn some, but not all, of how to do just that.

Like Sonic Pi this manual has an overriding design principle - to get from nothing to make a noise as quickly as possible.

With Sonic Pi that's just:

```ruby
play :beep 40
```

With Super Collider it is nearly as fast.

One of the key differences between Super Collider and Sonic Pi is that Sonic Pi is sound-based (play this sound for this time period) and Super Collider is state-based - get this synthesiser into this state. By default sounds in Super Collider are of indefinite duration. The Super Collider version of `play :beep 40` is:

```supercollider
something here
```

Will play ***forever***.