require_relative '../lib/collector.rb'
require_relative '../lib/authenticater.rb'
require_relative '../lib/writer.rb'
require_relative '../lib/cleaner.rb'
require 'bundler/setup'
Bundler.require

(keyword, account_id, ary_type, result_type, lang) = ARGV
writer = Writer.new(keyword)
writer.make_dir
client = Authenticater.new(account_id).get_twitter_client
collector = Collector.new(keyword, result_type, lang)
cleaner = Cleaner.new(ary_type)
ary_error = []
ary_all_tweets = []
ary_id = []

# 同時刻の多重起動を防ぐため取得の実行前にsleep
sleep_time = account_id.to_i % 9
sleep(sleep_time)

5.times do
    tweet_id = nil
    result = collector.search_tweet(client)
    # 出力先をツイートとエラーのどちらにするかを判断
    result.class == Array ? tweets = result : ary_error << result

    tweets.each {|tweet|
        ary_tweet = []
        tweet_id = tweet[:id]
         # ツイートが取得できていればそのidをインスタンス変数since_idに代入
        collector.since_id = tweet_id if tweet_id
        # ツイート要素からtweet配列を作成
        ary_tweet = cleaner.create_ary_tweet(tweet)
        tweet = cleaner.join_tweet_status(ary_tweet)
        ary_all_tweets << tweet
    }
    # ツイートが1件でも取得できていればそのidをid配列に格納
    ary_id << tweet_id if tweet_id
    # ファイルへの出力処理
    writer.output_tweet(ary_all_tweets)
    writer.output_error(ary_error) unless ary_error.empty?
    unless ary_id.empty?
        collector.clear_idfile
        writer.output_id(ary_id)
    end
    sleep(8)
    ary_all_tweets = []
    ary_id = []
    ary_error = []
end

