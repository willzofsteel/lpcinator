desc 'generate test waveform wav file'
task :waveform do |args|
  options = {}

  OptionParser.new(args) do |opts|
    opts.banner = "Usage: rake test_waveform [options]"
    [
      { :output => "Output file for test waveform" },
      { :samplerate => "Sample rate" },
      { :duration => "Length of signal" },
      { :phase => "Phase shift of signal" },
      { :amplitude => "Amplitude of signal" },
      { :frequency => "Frequency in hz" },
      { :channels => "Number of channels" },
    ].each do |hash|
      hash.each do |option, desc|
        opts.on("-#{option.to_s[0]}", "--#{option} {value}", desc, String) do |value|
          if value.include?(',') 
            options[option] = value.split(',').map(&:to_i).uniq
          else
            options[option] = value.to_i
          end
        end
      end
    end
  end.parse!

  start_time = Time.now.to_f
  waveform = Waveform.new(options)
  puts "Creating waveform at #{waveform.output} with #{waveform.description}"
  waveform.generate!
  seconds = "%0.4f" % (Time.now.to_f - start_time)
  puts "Success! Generated #{waveform.number_of_samples} in #{seconds} seconds"

  exit 0
end
