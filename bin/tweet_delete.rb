require_relative '../lib/authenticater.rb'
require_relative '../lib/compressor.rb'
require_relative '../lib/uploader.rb'
require 'bundler/setup'
Bundler.require

dir, extension = ARGV
raise 'Target directory, Extension are required' unless extension
compressor = Compressor.new(dir, extension)

compressor.delete_old_ltsv
compressor.delete_old_gzip
