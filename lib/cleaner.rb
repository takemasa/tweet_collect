class Cleaner

    def initialize
        @tweets_ary = []
        @error_ary = error_ary
        @id_ary = id_ary
    end
    attr_accessor :tweets_ary
    attr_accessor :error_ary
    attr_accessor :id_ary

    def get_retweeted(retweeted_text)
        @text = "RT #{retweeted_text}" if retweeted_text
    end

    def modify_tweet_status_str(tweet_text)
        tweet_text.gsub(/(\r\n|\r|\n|\t)/," ").gsub(":","")
    end

    def modify_twitter_client_str(twitter_client)
        @client = twitter_client.gsub(/<.*">/,"").gsub(/<\/a>/,"").gsub(/(\r\n|\r|\n|\t)/," ")
    end

    def set_label(label, tweet_status)
        "#{label}#{tweet_status}"
    end

    def create_tweet_ary
        @tweet_ary = [
            tweet.created_at,
            tweet.text,
            tweet.id,
            tweet.source,
            tweet.place.full_name,
            tweet.retweet_count,
            tweet.user.friends_count,
            tweet.user.followers_count,
            tweet.user.screen_name,
            tweet.user.id,
            tweet.user.statuses_count
        ]
    end

    def join_tweet_status(tweet)
        tweet.join("\t")
    end

    def add_tweets_ary(joined_tweet)
        @tweets_ary << joined_tweet
    end
end