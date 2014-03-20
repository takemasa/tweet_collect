# 実行時引数として、アップロードするファイルの場所、拡張子、アップロード先バケット名の指定が必要
require_relative '../lib/authenticater.rb'
require_relative '../lib/compressor.rb'
require_relative '../lib/uploader.rb'
require 'bundler/setup'
Bundler.require

dir, extension, bucketname = ARGV
raise 'Target directory, Extension, Bucketname are required' unless bucketname
client = Authenticater.new.get_aws_client
compressor = Compressor.new(dir, extension)
compressor.compress_file

compressor.get_gzip_list.each{|gzfile|
    Uploader.new(gzfile, bucketname).upload(client, gzfile)
    sleep(3)
}