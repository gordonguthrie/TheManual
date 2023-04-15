# Chapter 4 - How built-in synths are defined in Sonic Pi

## The synth beep

Lets look at this, as it is what we are reimplementing:


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