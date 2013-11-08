# coding: utf-8
require 'bundler/setup'
Bundler.require

class Collector

    def initialize(keyword)
        @keyword = keyword
        @since_id = 0
        @text = nil
    end

    def search_tweet(client)
        client.search(@keyword, :count => 100, :result_type => "recent", :since_id => @since_id, :lang=>"ja").results.reverse.each do |tweet|
            return tweet
        end
    end
end

class Authenticate

    def initialize(account_num)
        @account_num = account_num
    end

    def twconfig(twitter = Twitter::Client)
        twaccount = YAML.load_file('./config/twaccount.yaml')
        if twaccount["consumer_key#{@account_num}"]
            client = twitter.new(
                :consumer_key => twaccount["consumer_key#{@account_num}"],
                :consumer_secret => twaccount["consumer_secret#{@account_num}"],
                :oauth_token => twaccount["oauth_token#{@account_num}"],
                :oauth_token_secret => twaccount["oauth_token_secret#{@account_num}"]
                )
        else
            return 'account_num not exist'
        end
    end
end


class Writer

    def initialize(keyword)
        @keyword = keyword
    end

    def last_id
        return 9999
    end
end
