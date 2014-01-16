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
tweets = []
ary_all_tweets = []
ary_id = []
5.times do
    tweet_id = nil
    tweet_text = nil
    # ツイート取得を実行
    result = collector.search_tweet(client)
    # 出力先をツイートとエラーのどちらにするかを判断
    result.class == Array ? tweets = result : ary_error << result

    tweets.each {|tweet|
        ary_tweet = []
        tweet_id = tweet.id
         # ツイートが取得できていればそのidをインスタンス変数since_idに代入
        collector.since_id = tweet_id if tweet_id
        # ツイートの文字列処理
        tweet_text = tweet.retweeted_status ? cleaner.get_retweeted(tweet.retweeted_status.text) : tweet.text
        tweet_text = cleaner.modify_tweet_status_str(tweet_text)
        tweet_client = cleaner.modify_twitter_client_str(tweet.source)
        retweeted_status = tweet.retweeted_status ? true : false
        tweet_place_status = tweet.place ? true : false
        tweet_place = tweet.place ? cleaner.modify_place_str(tweet.place.full_name) : cleaner.modify_place_str
        # ツイート要素からtweet配列を作成
        ary_tweet = cleaner.create_ary_tweet(tweet, tweet_text, tweet_client, retweeted_status, tweet_place_status, tweet_place)
        # 配列を\tで結合
        tweet = cleaner.join_tweet_status(ary_tweet)
        # 結合したツイートをall_tweets配列に格納
        ary_all_tweets << tweet
    }
    # ツイートが1件でも取得できていればそのidをid配列に格納
    ary_id << tweet_id if tweet_id
    sleep(5)
end

# ファイルへの出力処理
writer.output_tweet(ary_all_tweets)
writer.output_error(ary_error) unless ary_error.empty?
unless ary_id.empty?
    collector.clear_idfile
    writer.output_id(ary_id)
end