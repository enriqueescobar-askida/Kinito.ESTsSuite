#!/usr/bin/ruby -w

require 'optparse'
require 'mascot_analysis'

mascotDat = ""

# Check the input parameters
opts = OptionParser.new do |opts|
  opts.banner = <<END
  Synopsis:
    Parse a Mascot analysis results file (.dat) and display a summary of the content.

  Usage: ruby mascotParser.rb  [options]
END

  opts.on("-f", "--dat-file MASCOT_DAT", "The Mascot .dat file to parse") do |filename|
    mascotDat = filename
  end
  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit 1
  end
end

opts.parse!(ARGV)

# Parse the Mascot analysis results file
mascotAnalysis = MascotAnalysis.new
mascotAnalysis.parse IO.read(mascotDat)
print mascotAnalysis
