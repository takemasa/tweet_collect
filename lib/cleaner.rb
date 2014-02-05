class Cleaner

    def initialize(ary_type = nil)
        raise 'ary_type needed' unless ary_type
        @ary_type = ary_type
    end

    def modify_tweet_status_str(tweet_text)
        tweet_text.gsub(/(\r\n|\r|\n|\t)/," ").gsub(":","")
    end

    def modify_twitter_client_str(twitter_client)
        twitter_client.gsub(/<.*">/,"").gsub(/<\/a>/,"").gsub(/(\r\n|\r|\n|\t)/,"")
    end

    def modify_place_str(place = nil)
        place ? place.gsub(", ","\tplace_prefecture:") : "\tplace_prefecture:"
    end

    def modify_prof_urls(tweet_attrs)
        urls = []
        # if tweet_attrs &&
        if tweet_attrs[:description] && !tweet_attrs[:description][:urls].empty?
            tweet_attrs[:description][:urls].each do |url|
                urls << url[:expanded_url]
            end
        else
            urls << nil
        end
        urls.join(' , ')
    end

    def modify_text_urls(tweet_attrs)
        urls = []
        if !tweet_attrs[:urls].empty?
            tweet_attrs[:urls].each do |url|
                urls << url[:expanded_url]
            end
        else
            urls << nil
        end
        urls.join(' , ')
    end
    def set_label(label, tweet_status)
        "#{label}:#{tweet_status}"
    end
    private :set_label

    def create_ary_tweet (tweet, client, retweeted, place_status, place)

        created_at = set_label('created_at ', tweet.created_at) #ツイート日時
        tweet_id = set_label('tweet_id ', tweet.id) #ツイートID
        user_name = set_label('user_name ', tweet.user.screen_name) #ツイートしたユーザ名
        user_id = set_label('user_id ', tweet.user.id) #ユーザID
        user_profile = set_label('profile ', modify_tweet_status_str(tweet.user.description)) #ユーザのプロフィール
        prof_url = set_label('prof_url ', modify_prof_urls(tweet.attrs[:user][:entities])) #プロフィール文のURL
        text = set_label('text ', modify_tweet_status_str(tweet.full_text)) #ツイート本文
        text_url = set_label('text_url ', modify_text_urls(tweet.attrs[:entities])) #ツイートのURL
        client = set_label('client ', client) #ツイート時に使用したクライアント
        place_status = set_label('place_status ', place_status) #位置情報の有無
        place = set_label('place_city ', place) #位置情報
        friends_count = set_label('friends_count ', tweet.user.friends_count) #フォロー数
        followers_count = set_label('followers_count ', tweet.user.followers_count) #フォロワー数
        all_tweet_count = set_label('all_tweet_count ', tweet.user.statuses_count) #総ツイート数
        retweeted_status = set_label('retweeted ', retweeted) #リツイートであるか
        retweet_count = set_label('retweet_count ', tweet.retweet_count) #リツイートされた回数
        retweeted_user = set_label('retweeted_user ', tweet.retweeted_status.user.screen_name) if retweeted #リツイート元のユーザ名
        case @ary_type
        when 'simple'
            ary = [created_at, user_name, text]
        when 'numeric'
            ary = [created_at, user_id, tweet_id, retweet_count, friends_count, followers_count, all_tweet_count]
        when 'all'
            ary = [created_at, tweet_id, user_name, user_id, user_profile, prof_url, text, text_url, client, place_status, place, friends_count, followers_count, all_tweet_count, retweeted_status, retweet_count, retweeted_user]
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