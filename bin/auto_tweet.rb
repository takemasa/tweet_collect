require_relative '../lib/authenticater.rb'
require 'bundler/setup'
Bundler.require

tw_username = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/../config/twaccount.yaml')) # idが記述されている
tweets = open(File.expand_path(File.dirname(__FILE__) + '/../config/tweets_script.txt')).read.split("\n").delete_if { |tweet| tweet.strip.empty? }

all_account_ids = 1 # 保持している総アカウント数が入る
ary_account_ids = []

while tw_username["username_#{all_account_ids}"]
    all_account_ids += 1
end
all_account_ids -= 1
ary_account_ids = (1..all_account_ids).to_a

3.times do
        Parallel.each(ary_account_ids, in_threds: 4) do |account_id|
            tweet = tweets.sample
            sleep_time = rand(600) #3600 1分~60時間の間隔でtweet
            puts "#{account_id} : #{tw_username["username_#{account_id}"]} : sleep #{sleep_time}"
            sleep sleep_time
            puts "#{tw_username["username_#{account_id}"]} tweet #{tweet} (#{Time.now})"
            Authenticater.new(account_id).get_client.update tweet
        end
end