/*
# Chapter 2 - Recreating the sine synth

## Improving our first synthesiser

There are somethings we will have to do to make it usable:

* it will need to turn off and not play endlessly. Sonic Pi expects notes to have a duration
* we will need to be able to pass the note in so it will play different notes
     * Sonic Pi expresses notes in terms of the midi note table, so `A4` not `440hz` - the synth will need to be able to accept Sonic Pi notes in and convert them into frequencies on the way out
* we will want to be able to make the note louder or quieter

*/

