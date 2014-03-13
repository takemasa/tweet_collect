require_relative '../lib/converter.rb'
require_relative '../lib/parser.rb'
require 'bundler/setup'

filenames = []
puts 'Convert filename?(./refine_search/*)'
puts 'Input "exit"'
while true
    convert_filename = STDIN.gets.chomp
    break if convert_filename == "exit"
    filenames << convert_filename
end

Parser.new(filenames)