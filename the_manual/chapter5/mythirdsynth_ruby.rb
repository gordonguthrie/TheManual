=begin
# Chapter 5 - Recreating the beep synth

## The third version of our new beep

We need to add this class definition to the file `synthifo.rb` under the path `app/server/ruby/lib/sonicpi/synths`

The name needs to be variable (ie no spaces or funky characters please).
=end

    class MyThirdSynth < SonicPiSynth
      def name
        "My Beep V3"
      end

      def introduced
        Version.new(5,0,0)
      end

      def synth_name
        "mythirdsynth"
      end

      def doc
        "my sine wave improved"
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

          :sustain => 1 # WATCH OUT! - see the 2nd synth for why this isn't `duration`
        }
      end
    end

    
# We also need to add this line to the `BaseInfo` class under the variable name `@@synth_infos`

        :mythirdsynth => MyThirdSynth.new,
