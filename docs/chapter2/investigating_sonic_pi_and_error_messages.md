# Chapter 2 - How synths are currently defined and invoked

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
play notes: 60
```

```
{run: 12, time: 0.0}
 └─ synth :beep, {notes: 60, note: 52.0}
```

The sound has changed - the note played is different. What's that about?

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

 So what we type into Sonic Pi is not what is being played - the term of art for this is munging - the inputs are being munged into something else.


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

Lets add a non-existant paramater to our call:

```ruby
play :c4, pan: 0.3, gordon: 99
```

It seems to be kept:

```
{run: 28, time: 0.0}
 └─ synth :beep, {note: 60.0, pan: 0.3, gordon: 99}
```

But look what happens when we try and pass a duff value to a known parameter:

```ruby
play :c4, pan: [3, 4, 5], gordon: 99
```

We get an error message:

```
Runtime Error: [buffer 5, line 1] - RuntimeError
Thread death!
Unable to normalise argument with key :pan and value [3, 4, 5]
```

## Custom synths