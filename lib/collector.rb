# require 'bundler/setup'
# Bundler.require

class Collector

    def initialize(keyword)
        @keyword = keyword
        @since_id = 0
    end

    def search_tweet(client)
        @tweet = []
        client.search(@keyword, :count => 100, :result_type => "recent", :since_id => @since_id, :lang=>"ja").results.reverse.each do |tweet|
            @tweet << tweet
        end
    end
     attr_accessor :tweet
end