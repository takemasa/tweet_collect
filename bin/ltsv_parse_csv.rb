# extract_transform内の.gzファイルを変換
require_relative '../lib/parser.rb'
require 'bundler/setup'
Bundler.require(:report)

filenames = []
Dir.glob("./extract_transform/**/*.ltsv.gz").each do |file|
    filenames << file
end

Parser.new(filenames)