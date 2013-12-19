require_relative '../lib/authenticater.rb'
require_relative '../lib/compressor.rb'
require_relative '../lib/uploader.rb'
require 'bundler/setup'
Bundler.require

client = Authenticater.new.get_aws_client
compressor = Compressor.new
compressor.compress_file

compressor.gzip_files.each{|gzfile|
    Uploader.new(gzfile).upload(client, gzfile)
}