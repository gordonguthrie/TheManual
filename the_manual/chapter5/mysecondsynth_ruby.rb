=being
# Chapter 5 - Recreating the bep synth

We need to add this class definition to the file `synthifo.rb` under the path `app/server/ruby/lib/sonicpi/synths`

The name needs to be variable (ie no spaces or funky characters please).

Why do we have to set a non-prefix?
=end

 class MySecondSynth < SonicPiSynth
      def name
        "My Beep 0.2"
      end

      def introduced
        Version.new(5,0,0)
      end

      def synth_name
        "mysecondsynth"
      end

      def doc
        "my sine wave"
      end

      def prefix
        ""
      end

      def arg_defaults
        {
          :note => 52,
          :amp => 1,
          :pan => 0,
          :release => 1,
        }
      end
    end
    
# We also need to add this line to the `BaseInfo` class under the variable name `@@synth_infos`

        :my_shonky_beep_2 => MySecondSynth.new,
