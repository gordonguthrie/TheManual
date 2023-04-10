# Chapter 4 - How built-in synths behave

## Philosophy

One of the working philosophies of Sonic Pi is that the tech shouldn't get in the way of experimentation.

All the built-in synths share common parameters - some have additional parameters. The idea is that if you have some running code (or are live coding) and you swap out one synth for another then bad things SHOULDN'T happen - it should behave much as you expected and not in a surprising way.

This section is going to look at [synthinfo.rb](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/synths/synthinfo.rb).

## BaseInfo

All synthesiser objects inherit from the base class `BaseInfo` mostly by the chain of indirection: `SonicPiSynth < SynthInfo < BaseInfo`.

But looking at all the synthesiser classes we see a simple pattern synths come in families and often descend from a common base class.

Note that sometimes synth names are just aliases for each other `sine`/`beep` and `mod_sine`/`mod_beep`. This aliasing happens in the global variable [@@synth_info](https://github.com/sonic-pi-net/sonic-pi/blob/710107fe22c5977b9fa5e83b71e30f847610e240/app/server/ruby/lib/sonicpi/synths/synthinfo.rb#L8118).

| Synth name        | Base Class        |
|-------------------|-------------------|
| Bass Foundation   | SonicPiSynth      |
| Bass Highend      | SonicPiSynth      |
| Beep              | SonicPiSynth      |
| Blade/SynthViolin | SonicPiSynth      |
| Bnoise            | Noise             |
| Chipbass          | SonicPiSynth      |
| Chiplead          | SonicPiSynth      |
| Chipnoise         | Noise             |
| Cnoise            | Noise             |
| Dark Ambience     | SonicPiSynth      |
| Dpulse            | Dsaw              |
| Dsaw              | SonicPiSynth      |
| Dtri              | Dsaw              |
| Dull Bell         | SonicPiSynth      |
| Fm                | SonicPiSynth      |
| Gnoise            | Noise             |
| Growl             | SonicPiSynth      |
| Hollow            | SonicPiSynth      |
| Hoover            | SonicPiSynth      |
| SynthKalimba      | SonicPiSynth      |
| Mod Beep          | alias for ModSine |
| Mod Dsaw          | SonicPiSynth      |
| Mod Fm            | FM                |
| Mod Pulse         | SonicPiSynth      |
| Mod Saw           | SonicPiSynth      |
| Mod Sine          | SonicPiSynth      |
| Mod Tri           | SonicPiSynth      |
| Noise             | Pitchless         |
| Organ Tonewheel   | SonicPiSynth      |
| SynthPiano        | SonicPiSynth      |
| SynthPluck        | SonicPiSynth      |
| Pnoise            | Noise             |
| Pretty Bell       | DullBell          |
| Prophet           | SonicPiSynth      |
| Pulse             | Square            |
| Rodeo             | SonicPiSynth      |
| Saw               | Beep              |
| Sine              | alias for Beep    |
| Square            | SonicPiSynth      |
| Subpulse          | Pulse             |
| Supersaw          | SonicPiSynth      |
| Tb303             | SonicPiSynth      |
| Tech Saws         | SonicPiSynth      |
| Tri               | Pulse             |
| Winwood Lead      | SonicPiSynth      |
| Zawa              | SonicPiSynth      |

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

