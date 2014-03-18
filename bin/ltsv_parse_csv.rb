require_relative '../lib/parser.rb'
require 'bundler/setup'
Bundler.require(:report)

filenames = []
puts 'Convert filename?(./refine_search/*)'
puts 'Input "end"'
while true
    convert_filename = STDIN.gets.chomp
    break if convert_filename == "end"
    filenames << convert_filename
end
Parser.new(filenames)