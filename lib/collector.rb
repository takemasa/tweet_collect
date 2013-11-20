# require 'bundler/setup'
# Bundler.require

class Collector

    def initialize(keyword , lang = 'ja', result_type = "recent", count = 100)
        @keyword = keyword
        @since_id = 0
        @lang = lang
        @result_type = result_type
        @count = count
    end

    def search_tweet(client) # searchによって取得したTwitter::Tweetクラスのオブジェクトを100件返す
        @tweet = []
        client.search(@keyword, :count => 100, :result_type => @result_type, :since_id => @since_id, :lang=>@lang).results.reverse.each do |tweet|
            @tweet << tweet
        end
        rescue Twitter::Error => e
            raise "error_time:#{Time.now}", "class:#{e.class}  message:#{e.message}"
    end
     attr_accessor :tweet
end