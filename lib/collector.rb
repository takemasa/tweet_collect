# require 'bundler/setup'
# Bundler.require

class Collector

    def initialize(keyword)
        @keyword = keyword
        @since_id = 0
        @tweet = nil
    end
    attr_accessor :since_id
    attr_accessor :tweet

    def search_tweet(client)
        client.search(@keyword, :count => 100, :result_type => "recent", :since_id => @since_id, :lang=>"ja").results.reverse.each do |tweet|
            return @tweet = tweet
        end
    end
end