class Cleaner

    def initialize(ary_type = 'all')
        @ary_type = ary_type
    end

    def get_retweeted(retweeted_text)
        "RT #{retweeted_text}" if retweeted_text
    end

    def modify_tweet_status_str(tweet_text)
        tweet_text.gsub(/(\r\n|\r|\n|\t)/," ").gsub(":","")
    end

    def modify_twitter_client_str(twitter_client)
        twitter_client.gsub(/<.*">/,"").gsub(/<\/a>/,"").gsub(/(\r\n|\r|\n|\t)/,"")
    end

    def modify_place_str(place = nil)
        place ? place.gsub(",","\tplace_prefecture:") : "\tplace_prefecture:"
    end

    def set_label(label, tweet_status)
        "#{label}:#{tweet_status}"
    end
    private :set_label

    def create_ary_tweet (tweet, text, client, place)

        created_at = set_label('created_at', tweet.created_at)
        user_name = set_label('user_name', tweet.user.screen_name)
        user_id = set_label('user_id', tweet.user.id)
        text = set_label('text', text)
        tweet_id = set_label('tweet_id', tweet.id)
        client = set_label('client', client)
        retweet_count = set_label('retweet_count', tweet.retweet_count)
        friends_count = set_label('friends_count', tweet.user.friends_count)
        followers_count = set_label('followers_count', tweet.user.followers_count)
        all_tweet_count = set_label('all_tweet_count', tweet.user.statuses_count)
        place = set_label('place_city', place)

        case @ary_type
        when 'simple'
            ary = [created_at, user_name, text]
        when 'numeric'
            ary = [created_at, user_id, tweet_id, retweet_count, friends_count, followers_count, all_tweet_count]
        when 'all'
            ary = [created_at, user_name, user_id, text, tweet_id, client, retweet_count, friends_count, followers_count, all_tweet_count, place]
        end
        ary
    end

    def join_tweet_status(tweet)
        tweet.join("\t")
    end

    def add_tweets_ary(joined_tweet)
        tweets_ary = []
        tweets_ary << joined_tweet
    end
end