# require 'bundler/setup'
# Bundler.require
require File.expand_path(File.dirname(__FILE__) + '/writer.rb')

class Collector

    def initialize(keyword, result_type = "recent", lang = 'ja')
        @keyword = keyword
        @id_filename = Writer.new(keyword).create_id_filename # requireしなくてもapp.rbで書けば呼べる
        @since_id = get_since_id
        @lang = lang
        @result_type = result_type
    end
    attr_reader :since_id

    def get_since_id
        since_id = 0
        File.open(File.expand_path(File.dirname(__FILE__) + "/../tweet/#{@id_filename}"),'a+') {|f|
            since_id = f.readlines[-1].to_i
        }
        since_id ? since_id : 0
    end

    def clear_idfile
        File.open("./tweet/#{@id_filename}",'w')
    end

    def search_tweet(client) # searchによって取得したTwitter::Tweetクラスのオブジェクトを100件返す
        tweets = []
        client.search(@keyword, :count => 100, :result_type => @result_type, :since_id => @since_id, :lang => @lang).results.reverse.each do |tweet|
            tweets << tweet
        end
        tweets
        rescue Twitter::Error => e
            raise "error_time:#{Time.now}", "class:#{e.class}  message:#{e.message}"
    end
end