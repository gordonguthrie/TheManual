# Chapter 1 - First beeps

## Sonic Pi and SuperCollider

[Sonic Pi](https://sonic-pi.net/) is a user-friendly live-coding environment that lets people start making music very quickly and is focussed on ease of use and quick starts.

The heavy lifting of making actual noises in Sonic Pi is provided by [SuperCollider](https://supercollider.github.io/) which is a full-blown sonic engine for making and manipulating audio signals. SuperCollider is far from user-friendly requiring a high degree of both programming skill and a profound understanding of synthesiser design.

## What is the purpose of this manual?

### In scope - custom synths

Sonic Pi has a great range of synthesisers but there is always room for more. This manual will make it easier for a small number of synthesiser designers and developers to make a much large range of synthesisers and effects available to the very large community of normal users of Sonic Pi.

The goal of this project is to enable a small community of sound sculptors to build new synthesisers for the large community of live coders to incorporate by demystifying the messy business of making one coding paradigm available in a completely foreign one.

It is a step-by-step manual explaining in detail the intricacies of the relationship between the Sonic Pi front end and the SuperCollider back end.

It is not a substitute for [Sonic Pi book](https://www.amazon.co.uk/Code-Music-Sonic-Sam-Aaron/dp/1908256877) or the [SuperCollider book](https://mitpress.mit.edu/9780262232692/the-supercollider-book/).

### Out of scope - custom FXs

As we go through the book it will become clear that SuperCollider is used for all things that make sounds in Sonic Pi, synths, samples and effects (FXs). This book only covers synths.

## Who is this for?

This manual is for people who can **already** use [Sonic Pi](https://sonic-pi.net/) and now want to learn how to build additional synthesisers for Sonic Pi in [SuperCollider](https://supercollider.github.io/).

SuperCollider offers functionality that allows you **build** and **play** synthesisers.

This manual focusses on **building** them only: for people to play them using Sonic Pi.

SuperCollider is a major programming environment in its own right and to learn how to get the most out of it you will need to study it.

To learn how to do this, you will need to install SuperCollider.

## What does it cover?

### Chapter 1 - First Beeps

This chapter shows you how to make a beep in SuperCollider and then how to make that same beep from within Sonic Pi.

### Chapter 2 - Existing synths in Sonic Pi

This chapter looks at the existing synths and the two different ways they are implemented - the old way (Overtone) and the new approved way (SuperCollider).

## Chapter 3 - Deep dive

This OPTIONAL chapter does a deep dive into how synths are loaded and invoked - not strictly necessary for you to absorb all this to write your own synths.

## Chapter 4 - How built-in synths behave

The chapter goes through how built in synths behave in terms of:

* parameters, default values and validations
* error messages
* integration with the documentation/in Sonic Pi help
* in relation to other synths - to be well behaved members of the Sonic Pi synth family

## Chapter 5 - Recreating the beep synth

In this chapter it all comes together and we rebuild our own version of the Beep synthesiser directly in SuperCollider and integrate it into our Sonic Pi instance.

## Chapter 6 - Next steps

What the future holds for this manual and user-defined synths in Sonic Pi
