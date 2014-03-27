# extract_transform内の.gzファイルを変換
require_relative '../lib/authenticater.rb'
require_relative '../lib/getrefinesearchconfig.rb'
require_relative '../lib/gettweetfroms3.rb'
require_relative '../lib/parser.rb'
require_relative '../lib/compressor.rb'
require_relative '../lib/uploader.rb'
require 'bundler/setup'
Bundler.require(:report)
require 'date'

t0 = Time.now
yesterday = (Date.today-1).to_s
year = yesterday[0, 4]
month = yesterday[5, 2]
client = Authenticater.new.get_aws_client
keywordtags = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "/../config/twkeyword.yaml"))
files = []
keywordtags.each do |tag|
    puts "get #{tag[1]}/#{year}/#{month}/#{yesterday}*.ltsv.gz"
    file = "#{tag[1]}/#{year}/#{month}/#{yesterday}"
    files << GetTweetFromS3.new('./extract_transform').download(client, file) unless GetTweetFromS3.new('./extract_transform').avoid_duplication(file)
end
puts GetTweetFromS3.new('./extract_transform').file_exists?(files)


filenames = []
Dir.glob("./extract_transform/**/*.ltsv.gz").each do |file|
    filenames << file
end

Parser.new(filenames)

dir, extension, bucketname = "./extract_transform", "csv", "dsb-twitter-csv"
compressor = Compressor.new(dir, extension)
compressor.compress_file

compressor.get_gzip_list.each{|gzfile| Uploader.new(gzfile, bucketname).upload(client, gzfile)}
compressor.delete_old_files
compressor.delete_old_gzip

t1 = Time.now
puts  "Process Time: #{t1 - t0} sec"