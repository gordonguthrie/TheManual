# Chapter 3 - Deep dive

## How does it all work?

This chapter will help you understand how Sonic Pi plays synths  - but it is not strictly necessary for you to understand that to just add your own synths written in SuperCollider.

## Stop, look and listen!

```
  _    _            _
 | |  | |          | |
 | |__| | ___ _   _| |
 |  __  |/ _ \ | | | |
 | |  | |  __/ |_| |_|
 |_|  |_|\___|\__, (_)
               __/ |
              |___/
```

Don't feel that you ***MUST*** read this chapter, you can skip it if you want.

If you want to add your own well-behaved user-defined synth in Sonic Pi and compile it in so it works as native you can just skip this chapter.

But if you want your synth to be a bit funky, to not work quite like the built-in ones then you will need to take a swatch at the source code to figure out why it works as it does and how your synth may or may nor work with all the features of Sonic Pi.

This section doesn't cover all the pathways by which your synth will be called, nor is it exhaustive in the one, main pathway it explores - its job is to cut a track through the jungle - its up to you to make the journey

## Small apology

Its been 25 years since last I wrote Ruby in anger, I can sort-of read it still, but not write it, so ***caveat lector/reader beware***.