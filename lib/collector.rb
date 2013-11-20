# require 'bundler/setup'
# Bundler.require
require 'writer.rb'

class Collector

    def initialize(keyword , lang = 'ja', result_type = "recent", count = 100)
        @keyword = keyword
        @id_filename = Writer.new(keyword).create_id_filename
        @since_id = get_since_id
        @lang = lang
        @result_type = result_type
        @count = count
    end
    attr_reader :since_id

    def get_since_id
        since_id = 0
        File.open("./tweet/#{@id_filename}",'a+') {|f|
            since_id = f.readlines[-1].to_i
        }
        since_id ? since_id : 0
    end

    def clear_idfile
        File.open("./tweet/#{@id_filename}",'w')
    end

    def search_tweet(client) # searchによって取得したTwitter::Tweetクラスのオブジェクトを100件返す
        @tweet = []
        client.search(@keyword, :count => @count, :result_type => @result_type, :since_id => @since_id, :lang => @lang).results.reverse.each do |tweet|
            @tweet << tweet
        end
        rescue Twitter::Error => e
            raise "error_time:#{Time.now}", "class:#{e.class}  message:#{e.message}"
    end
     attr_accessor :tweet
end