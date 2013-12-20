require_relative '../lib/authenticater.rb'
require_relative '../lib/compressor.rb'
require_relative '../lib/uploader.rb'
require 'bundler/setup'
Bundler.require

compressor = Compressor.new

compressor.delete_old_ltsv
compressor.delete_old_gzip
