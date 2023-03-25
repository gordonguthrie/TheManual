# Chapter 2 - Existing Synths in Sonic Pi

## Investigating Sonic Pi and error messages

We can learn a lot about how a system works by using it and also looking at error messages, so lets try and break Sonic Pi and see what we can learn.

Lets just muck about with this programme, first with a built-in Sonic Pi synth (by default `beep`) and then with our own one.

## Built-in synths

```ruby
play 60
```

We get the log:

```
{run: 8, time: 0.0}
 └─ synth :beep, {note: 60.0}
```

The integer note `60` has become a float `6.0` but we can use floats in our play command quite happily too:

```ruby
play 60.0
```

gives:

```
{run: 42, time: 0.0}
 └─ synth :beep, {note: 60.0}
```

We haven't named the note argument but we can, and we get the same result:

```
play note: 60
```

We can swap the number of the note out for a symbol:

```ruby
play :c4
```

Which resolves to the Midi note `60` as we expect:

```
{run: 24, time: 0.0}
 └─ synth :beep, {note: 60.0}
```

But if we play not a `note` but `notes` we get a different result:

```ruby
play notes: [60, 62, 65]
```

```
{run: 37, time: 0.0}
 └─ synth :beep, {note: [60.0, 62.0, 65.0]}
```

So the `notes` parameter has magically been transformed into `note` with a list.

What happens if we use a `notes` parameter without a list?

```ruby
play notes: 60
```

The sound has changed - the note played is different. What's that about?

```
{run: 38, time: 0.0}
 └─ synth :beep, {notes: 60, note: 52.0}
```

So whereas when we passed a list tagged `notes` SonicPi recognised it as a list and said, "ooh, notes is just the plural of note, lets move this value to the note slot".

We can go crazy and bung a nutty list in there:

```ruby
play notes: [60, chord(:c3, :minor), [55, 57, 59]]
```

and Sonic Pi just goes "you are having a giraffe m8":

```
{run: 40, time: 0.0}
 └─ synth :beep, {note: [60.0, nil, nil]}
```

Sonic Pi just saying "I don't know what these things are but they are not numbers so into the bin with them".

We can change the note to a chord:

```ruby
play chord(:e3, :minor)
```

Now the synthesiser is turning that chord into a list of notes:

```
{run: 18, time: 0.0}
 └─ synth :beep, {note: [52.0, 55.0, 59.0]}
 ```

 But a chord isn't a list of notes, its a data structure called a ring:

 ```ruby
 print(chord(:e3, :minor))
 ```

gives:

 ```
(ring <SonicPi::Chord :E :minor [52, 55, 59])
 ```

So something inside Sonic Pi is taking the ring data structure (which contains a list and information about the list like how long it is and code to enable indexes to be mapped to an element in the list) and pulling the list out.

What we type into Sonic Pi is not what is being played - the term of art for this is munging - the inputs are being munged into something else.


We can play a chord explicitly too:

```ruby
play [52, 55, 59]
```

giving:

```
{run: 20, time: 0.0}
 └─ synth :beep, {note: [52.0, 55.0, 59.0]}
```

Obviously we can add other attributes:

```ruby
play :c4, pan: 0.3
```

gives:

```
{run: 25, time: 0.0}
 └─ synth :beep, {note: 60.0, pan: 0.3}
```

Lets add a non-existent parameter to our call:

```ruby
play :c4, pan: 0.3, gordon: 99
```

It seems to be kept:

```
{run: 28, time: 0.0}
 └─ synth :beep, {note: 60.0, pan: 0.3, gordon: 99}
```

Just for badness, trust me it will make sense later, lets go again with a non-option but make it `out`:

```ruby
play 60, out: 3
```

and as you would expect the note plays:

```
{run: 55, time: 0.0}
 └─ synth :beep, {note: 60.0, out: 3}
```

What happens if we try and leave out the note, is there a default value here? The result from passing in a single value in `notes` would tend to suggest there is:

```ruby
play pan: 0.3
```

as we suspected:

```
{run: 36, time: 0.0}
 └─ synth :beep, {pan: 0.3, note: 52.0}
```

But look what happens when we try and pass a duff value to a known parameter:

```ruby
play :c4, pan: [3, 4, 5], gordon: 99
```

we get an error message:

```
Runtime Error: [buffer 5, line 1] - RuntimeError
Thread death!
Unable to normalise argument with key :pan and value [3, 4, 5]
```

And the same if we try and bust the bounds. The `pan` parameter places the sound on the left/right pan with -1.0 being hard left and 1.0 being hard right:

```ruby
play 60, pan: 3
```

throws an error:

```
Runtime Error: [buffer 5, line 5] - RuntimeError
Thread death!
Value of opt :pan must be a value between -1 and 1.0 inclusively, got 3
```

And if we try and use `play` without a number, symbol or list we also get a crash:

```ruby
play :juicyfruit
```

resulting in:

```
Runtime Error: [buffer 5, line 5] - SonicPi::Note::InvalidNoteError
Thread death!
Invalid note: :juicyfruit
```

## Custom synths

If we switch to our `myfirstsynth` we get a slightly different story:

```ruby
load_synthdefs "/Users/gordonguthrie/.synthdefs"

use_synth(:myfirstsynth)

play 60
```

This plays (in mono) the same sound as `beep`:

```
{run: 29, time: 0.0}
 └─ synth :myfirstsynth, {note: 60}
 ```

We can throw options (sensible or otherwise at it):

 ```ruby
 load_synthdefs "/Users/gordonguthrie/.synthdefs"

use_synth(:myfirstsynth)

play 60, pan: 3, gordon: 99
```

and it just plays:

```
{run: 30, time: 0.0}
 └─ synth :myfirstsynth, {note: 60, pan: 3, gordon: 99}
```

When we read the code for our synthesizer we realise this is a bit odd. Our function only takes one argument `out` and yet we are calling it with 3, none of which is `out`.

```supercollider
(SynthDef("myfirstsynth", {arg out = 0;
     var note, envelope;
     envelope = Line.kr(0.1, 0.0, 1.0, doneAction: 2);
     note = SinOsc.ar(440, 0, envelope);
     Out.ar(out, note);
}).writeDefFile("/Users/gordonguthrie/.synthdefs"))
```

So whatever parameters we send are all being chucked away - apart from `out`. What happens if we actually pass in an `out` parameter:

```ruby
load_synthdefs "/Users/gordonguthrie/.synthdefs"

use_synth(:myfirstsynth)

play 60, out: 3
```

Well the logs say all is well:

```
{run: 55, time: 0.0}
 └─ synth :beep, {note: 60.0, out: 3}
```

but actually there is no sound. To understand this we need to trace through where the `out` value is used in our code. We use it as the first parameter in the uGen `Out`. It determines the output channel. The way Sonic Pi is wired up the channel `0` makes our computer play noise, any other channel is not connected to something to turn signal into sound - hence the silence.

Lets look at some other incantations - particularly around notes.

```ruby
load_synthdefs "/Users/gordonguthrie/.synthdefs"

use_synth(:myfirstsynth)

play note: [60, 62, 66]
```

This no longer works:

```
Runtime Error: [buffer 5, line 5] - RuntimeError
Thread death!
Unable to normalise argument with key :note and value [60, 62, 66]
```

Switching to `notes` doesn't help either:

```ruby
load_synthdefs "/Users/gordonguthrie/.synthdefs"

use_synth(:myfirstsynth)

play notes: [60, 63, 65]
```

giving (essentially) the same error:

```
Runtime Error: [buffer 5, line 5] - RuntimeError
Thread death!
Unable to normalise argument with key :notes and value [60, 62, 66]
```

You can't play chords either. But a note-free incantation still works:

```ruby
load_synthdefs "/Users/gordonguthrie/.synthdefs"

use_synth(:myfirstsynth)

play pan: 44
```

Giving:

```
{run: 60, time: 0.0}
 └─ synth :myfirstsynth, {pan: 44}
```

## So what have we learned?

We have learned that Sonic Pi monkey's about with the parameters you have passed in before it sends them on to SuperCollider.

In the next section we will look at ways to find out what is happening in the code, and in the one after that we will peek inside Sonic Pi to figure out what's really going on.
