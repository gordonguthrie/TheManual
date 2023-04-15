# Chapter 4 - How built-in synths are defined in Sonic Pi

## Philosophy

One of the working philosophies of Sonic Pi is that the tech shouldn't get in the way of experimentation.

All the built-in synths share common parameters - some have additional parameters. The idea is that if you have some running code (or are live coding) and you swap out one synth for another then bad things SHOULDN'T happen - it should behave much as you expected and not in a surprising way.

This section is going to look at [synthinfo.rb](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/synths/synthinfo.rb).

## BaseInfo

All synthesiser objects inherit from the base class `BaseInfo` mostly by the chain of indirection: `SonicPiSynth < SynthInfo < BaseInfo`.

But looking at all the synthesiser classes we see a simple pattern synths come in families and often descend from a common base class.

Note that sometimes synth names are just aliases for each other `sine`/`beep` and `mod_sine`/`mod_beep`. This aliasing happens in the global variable [@@synth_info](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/synths/synthinfo.rb#L8118).

To be recognised as a synth you need to be added to the global variable `@@synth_infos` in `synthinfo.rb`.

The functions you must add are:
* name
* introduced
* synth_name
* doc

| Synth name        | Base Class        | arg_defaults | specific_arg_info |
|-------------------|-------------------|--------------|-------------------|
| Bass Foundation   | SonicPiSynth      | Yes          |                   |
| Bass Highend      | SonicPiSynth      | Yes          | Yes               |
| Beep/SynthViolin  | SonicPiSynth      | Yes          |                   |
| Blade             | SonicPiSynth      | Yes          | Yes               |
| Bnoise            | Noise             |              |                   |
| Chipbass          | SonicPiSynth      | Yes          | Yes               |
| Chiplead          | SonicPiSynth      | Yes          | Yes               |
| Chipnoise         | Noise             | Yes          | Yes               |
| Cnoise            | Noise             |              |                   |
| Dark Ambience     | SonicPiSynth      | Yes          | Yes               |
| Dpulse            | Dsaw              | Yes          | Yes               |
| Dsaw              | SonicPiSynth      | Yes          |                   |
| Dtri              | Dsaw              |              |                   |
| Dull Bell         | SonicPiSynth      | Yes          |                   |
| Fm                | SonicPiSynth      | Yes          | Yes               |
| Gnoise            | Noise             |              |                   |
| Growl             | SonicPiSynth      | Yes          |                   |
| Hollow            | SonicPiSynth      | Yes          | Yes               |
| Hoover            | SonicPiSynth      | Yes          |                   |
| (Synth) Kalimba   | SonicPiSynth      | Yes          | Yes               |
| Mod Beep          | alias for ModSine | Yes          |                   |
| Mod Dsaw          | SonicPiSynth      | Yes          |                   |
| Mod Fm            | FM                | Yes          |                   |
| Mod Pulse         | SonicPiSynth      | Yes          |                   |
| Mod Saw           | SonicPiSynth      | Yes          |                   |
| Mod Sine          | SonicPiSynth      | Yes          |                   |
| Mod Tri           | SonicPiSynth      | Yes          |                   |
| Noise             | Pitchless         | Yes          |                   |
| Organ Tonewheel   | SonicPiSynth      | Yes          | Yes               |
| (Synth) Piano     | SonicPiSynth      | Yes          | Yes               |
| (Synth) Pluck     | SonicPiSynth      | Yes          | Yes               |
| Pnoise            | Noise             |              |                   |
| Pretty Bell       | DullBell          |              |                   |
| Prophet           | SonicPiSynth      | Yes          |                   |
| Pulse             | Square            | Yes          |                   |
| (Synth) Rodeo     | SonicPiSynth      | Yes          | Yes               |
| Saw               | Beep              | Yes          |                   |
| Sine              | alias for Beep    | Yes          |                   |
| Square            | SonicPiSynth      | Yes          |                   |
| Subpulse          | Pulse             | Yes          | Yes               |
| Supersaw          | SonicPiSynth      | Yes          |                   |
| Tb303             | SonicPiSynth      | Yes          | Yes               |
| Tech Saws         | SonicPiSynth      | Yes          |                   |
| Tri               | Pulse             |              |                   |
| Winwood Lead      | SonicPiSynth      | Yes          | Yes               |
| Zawa              | SonicPiSynth      | Yes          | Yes               |

The base class broadly defines a well-behaved Sonic Pi synth, particularly in the function [default_arg_info](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/synths/synthinfo.rb#L329) which defines a complete set of arguments most built-in synthesisers accept.

We are going to reimplment `beep` so lets look at that:

```ruby
    class Beep < SonicPiSynth
      def name
        "Sine Wave"
      end

      def introduced
        Version.new(2,0,0)
      end

      def synth_name
        "beep"
      end

      def doc
        "A simple pure sine wave. The sine wave is the simplest, purest sound there is and is the fundamental building block of all noise. The mathematician Fourier demonstrated that any sound could be built out of a number of sine waves (the more complex the sound, the more sine waves needed). Have a play combining a number of sine waves to design your own sounds!"
      end

      def arg_defaults
        {
          :note => 52,
          :note_slide => 0,
          :note_slide_shape => 1,
          :note_slide_curve => 0,
          :amp => 1,
          :amp_slide => 0,
          :amp_slide_shape => 1,
          :amp_slide_curve => 0,
          :pan => 0,
          :pan_slide => 0,
          :pan_slide_shape => 1,
          :pan_slide_curve => 0,

          :attack => 0,
          :decay => 0,
          :sustain => 0,
          :release => 1,
          :attack_level => 1,
          :decay_level => :sustain_level,
          :sustain_level => 1,
          :env_curve => 2
        }
      end
    end
```
