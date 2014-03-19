require_relative '../lib/authenticater.rb'
require_relative '../lib/compressor.rb'
require_relative '../lib/uploader.rb'
require 'bundler/setup'
Bundler.require

bucketname = ARGV[0]
raise 'bucketname is required' unless bucketname
client = Authenticater.new.get_aws_client
compressor = Compressor.new
compressor.compress_file

compressor.get_gzip_list.each{|gzfile|
    Uploader.new(gzfile, bucketname).upload(client, gzfile)
    sleep(3)
}