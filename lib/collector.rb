# require 'bundler/setup'
# Bundler.require

class Collector

    def initialize(keyword)
        @keyword = keyword
        @since_id = 0
    end

    def search_tweet(client)
        client.search(@keyword, :count => 100, :result_type => "recent", :since_id => @since_id, :lang=>"ja").results.reverse.each do |tweet|
            # @created_at = tweet.created_at,
            # @text = tweet.text,
            # @tw_id =tweet.id,
            # @screen_name = tweet.user.screen_name,
            # @friends_count = tweet.user.friends_count,
            # @followers_count = tweet.user.followers_count,
            # @retweet_count = tweet.retweet_count,
            # @user_id = tweet.user.id,
            # @place = tweet.place.full_name,
            # @statuses_count = tweet.user.statuses_count,
            # @client = tweet.source
            # @retweeted_text = tweet.retweeted_status.text
            return @tweet = tweet
        end
        attr_accessor :tweet
    end
end