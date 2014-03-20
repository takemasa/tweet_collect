require_relative '../lib/authenticater.rb'
require_relative '../lib/getrefinesearchconfig.rb'
require_relative '../lib/gettweetfroms3.rb'
require 'bundler/setup'
Bundler.require
require 'date'

year = (Date.today-1).year
month = (Date.today-1).month < 10 ? "0#{(Date.today-1).month}" : "#{(Date.today-1).month}"
day = (Date.today-1).day < 10 ? "0#{(Date.today-1).day}" : "#{(Date.today-1).day}"
yesterday = "#{(Date.today-1).year}-#{month}-#{day}"

client = Authenticater.new.get_aws_client
keywordtags = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "/../config/twkeyword.yaml"))
files = []
keywordtags.each do |tag|
    puts "get #{tag[1]}/#{year}/#{month}/#{yesterday}*.ltsv.gz"
    file = "#{tag[1]}/#{year}/#{month}/#{yesterday}"
    files << GetTweetFromS3.new('./extract_transform').download(client, file) unless GetTweetFromS3.new('./extract_transform').avoid_duplication(file)
end
puts GetTweetFromS3.new('./extract_transform').file_exists?(files)