require_relative '../lib/collector.rb'
require_relative '../lib/authenticater.rb'
require_relative '../lib/writer.rb'
require_relative '../lib/cleaner.rb'
Dotenv.load
group = ENV['group'] ? ENV['group'] : :default
require 'bundler/setup'
Bundler.require(group)

(keyword, account_id, ary_type, result_type, lang) = ARGV
writer = Writer.new(keyword)
writer.make_dir
client = Authenticater.new(account_id).get_twitter_client
collector = Collector.new(keyword, result_type, lang)
cleaner = Cleaner.new(ary_type)
error_message = nil
ary_all_tweets = []
ary_id = []
ary_log = []
length = nil

# 同時刻の多重起動を防ぐため取得の実行前にsleep
sleep_time = account_id.to_i % 9
sleep(sleep_time)
execute_time = Time.now
5.times do
    tweet_id = nil
    result = collector.search_tweet(client, execute_time)
    # 出力先をツイートとエラーのどちらにするかを判断
    result.class == Array ? tweets = result : error_message = result
    if tweets
        length = tweets.length
        ary_log << length
        tweets.each do |tweet|
            ary_tweet = []
            tweet_id = tweet[:id]
         # ツイートが取得できていればそのidをインスタンス変数since_idに代入
            collector.since_id = tweet_id if tweet_id

            ary_tweet = cleaner.create_ary_tweet(tweet)
            tweet = cleaner.join_tweet_status(ary_tweet)
            ary_all_tweets << tweet
        end
    # ツイートが1件でも取得できていればそのidをid配列に格納
        ary_id << tweet_id if tweet_id
    # ファイルへの出力処理
        writer.output_tweet(ary_all_tweets)
        unless ary_id.empty?
            collector.clear_idfile
            writer.output_id(ary_id)
        end
    end
    writer.output_error(error_message) unless error_message.nil?
    sleep(10)
    ary_all_tweets = []
    ary_id = []
    error_message = nil
end
writer.output_log(ary_log)
