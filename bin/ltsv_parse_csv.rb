require_relative '../lib/converter.rb'
require_relative '../lib/parser.rb'
require 'bundler/setup'

filenames = []
puts 'Convert filename?(./refine_search/*)'
puts 'Input "end"'
while true
    convert_filename = STDIN.gets.chomp
    break if convert_filename == "end"
    filenames << convert_filename
end
print 'outputfilename?(./refine_search/*)'
newfilenames << STDIN.gets.chomp

Parser.new(filenames).write(newfilename)