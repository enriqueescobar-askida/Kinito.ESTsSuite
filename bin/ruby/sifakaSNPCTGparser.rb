#!/usr/bin/ruby -w
# Call using "ruby sifakaSNPCTGparser.rb -f a.txt"

require 'getoptlong'
require 'csv'
# specify the options we accept and initialize the option parser
opts          = GetoptLong.new(
  [ "--file", "-f",   GetoptLong::REQUIRED_ARGUMENT ]
);

# process the parsed options
sifakaSNPCTG  = "";
opts.each do |opt, arg|
  puts "Option: #{opt}, arg #{arg.inspect}"
  sifakaSNPCTG= arg;
end

if  File.exists?(sifakaSNPCTG)
  puts  File.atime(sifakaSNPCTG);
  puts  File.mtime(sifakaSNPCTG);
  puts  File.dirname(File.expand_path(sifakaSNPCTG));
  puts  File.basename(sifakaSNPCTG);
  puts  File.size(sifakaSNPCTG);
  puts  File.ftype(sifakaSNPCTG);
else
  puts  "File <"+sifakaSNPCTG+"> does no t exist!";
  exit(1);
end

# Read File with Exception Handling
counter       = 1;
begin
  CSV.open(sifakaSNPCTG, 'r', " ") do |line_array|
  snp_ID  = line_array[0];
  ctg_ID  = line_array[2];
  signus  = line_array[6];
  qrstar  = line_array[7].to_i;
  qrstop  = line_array[8].to_i;
  htstar  = line_array[9].to_i;
  htstop  = line_array[10].to_i;
  aligne  = line_array[11];
  ht_pos  = 31+htstar-qrstar;
  print counter," ",snp_ID," ",ctg_ID," ",signus," ",qrstar," ",qrstop
  print " ",htstar," ",htstop," ",aligne," ",ht_pos,"\n"
  counter = counter+1;
end

rescue        SystemCallError
  $stderr.print "IO Exception: "+$!;
  in_file.close;
  raise;
end


