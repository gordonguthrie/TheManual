# Chapter 5 - Recreating the beep Synth

## The `Env` uGen


We will use the `Env` uGen to build the asdr envelope for the synth. It builds a sound envelope. We can examine what the envelope looks like using the plot function in the SuperCollider IDE

Env.new(levels: [0, 1, 1, 1, 0], times: [0, 0, 0, 1], curve: Array.fill(4, 1)).plot;

This draws a lovely graph

![default declining envelope](../images/chapter5/plotting_envelopes.png)