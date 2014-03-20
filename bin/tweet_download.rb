# tweet_collect/config/search_config.yamlのfrom,to,keywordを指定してから実行
require_relative '../lib/authenticater.rb'
require_relative '../lib/getrefinesearchconfig.rb'
require_relative '../lib/gettweetfroms3.rb'
require 'bundler/setup'
Bundler.require


client = Authenticater.new.get_aws_client
filepath = GetRefineSearchConfig.new.create_filepath
files = []
filepath.each do |file|
    if GetTweetFromS3.new("./refine_search").avoid_duplication(file)
        puts "#{file}*.ltsv exists!"
    else
        puts "#{file}*.ltsv not exists"
    end
    files << GetTweetFromS3.new("./refine_search").download(client, file) unless GetTweetFromS3.new("./refine_search").avoid_duplication(file)
end

puts ""
files.each do |f|
    puts "got #{f}" if f
end
puts GetTweetFromS3.new("./refine_search").file_exists?(files)