require_relative '../lib/parser.rb'
require 'bundler/setup'
Bundler.require(:report)

filenames = []
Dir.glob("./extract_transform/**/*.ltsv").each do |file|
    filenames << file
end

Parser.new(filenames)