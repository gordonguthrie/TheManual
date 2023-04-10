# Chapter 6 - What's next

## Integration

At the moment the loading of a synth and the presentation of it as built in are in two separate places.

The load command doens't know or check if the synth description, parameters and validations are loaded. The runtime looks and treats synths one way if they are built in and a different way if they are not recognised.

The strategic view is to merge these two things - to have a load process that loads both the synthesiser and the synth description, parameters and validation.

The load process should enable user-defined synths to be well-behaved (ie behave like and are subject to the same possible transforms as built-in ones) or badly-behaved.

## The future of this manual

When there is a single integrated way of loading synths without recompiling the git repo that contains this manual will become a community library of different synths, that might be:

* well-behaved - have parameter sets aligned with the built in synths so that Sonic Pi is happy to do the standard transpositions and pitch shifts
* badly-behaved - have freaky parameters that might cause Sonic Pi to bork if the user mistypes or switches synths either live coding or in mucking about, or with odd ways of specifying notes that should not/cannot be subject to transpositions
* experimental

This manual is compiled with the [Literate Code Reader](https://gordonguthrie.github.io/literatecodereader/) escript which means that valid SuperCollider code will compile into a readable html page.

This means that simply by commiting a working SuperCollider synth for Sonic Pi it will be added to the book.
