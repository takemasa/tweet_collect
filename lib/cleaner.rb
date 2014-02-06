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

    def modify_urls(tweet_attrs)
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

    def create_ary_tweet (tweet, client, place_status, place)
        text_urls = modify_urls(tweet.attrs[:entities])
        prof_urls = modify_urls(tweet.attrs[:user][:entities][:description])
        home_urls = tweet.attrs[:user][:entities][:url] ? modify_urls(tweet.attrs[:user][:entities][:url]) : '' # ホームページのリンクが存在しない時は[:url]のハッシュが作られないため、空の配列を代入する
        url = prof_urls.empty? && home_urls.empty? ? false : true

        if tweet.retweeted_status
            retweeted, retweeted_username = true, tweet.retweeted_status.user.screen_name
        else
            retweeted, retweeted_username = false, nil
        end

        created_at = set_label('created_at', tweet.created_at) #ツイート日時
        tweet_id = set_label('tweet_id', tweet.id) #ツイートID
        text = set_label('text', modify_tweet_status_str(tweet.full_text)) #ツイート本文
        text_url = set_label('text_url', text_urls) #ツイートのURL
        user_name = set_label('user_name', tweet.user.screen_name) #ツイートしたユーザ名
        user_id = set_label('user_id', tweet.user.id) #ユーザID
        user_page = set_label('user_page', "https://twitter.com/intent/user?user_id=#{tweet.user.id}") #ユーザーページのURL
        user_profile = set_label('profile', modify_tweet_status_str(tweet.user.description)) #ユーザのプロフィール
        prof_url = set_label('prof_url', prof_urls) #プロフィール文のURL
        home_url = set_label('home_url', home_urls) #プロフィールのURL欄
        client = set_label('client', client) #ツイート時に使用したクライアント
        place_status = set_label('place_status', place_status) #位置情報の有無
        place = set_label('place_city', place) #位置情報
        friends_count = set_label('friends_count', tweet.user.friends_count) #フォロー数
        followers_count = set_label('followers_count', tweet.user.followers_count) #フォロワー数
        all_tweet_count = set_label('all_tweet_count', tweet.user.statuses_count) #総ツイート数
        listed_count = set_label('listed_count', tweet.user.listed_count) #リストに加えられている数
        url_status = set_label('url_status', url) # ツイート情報にURLが含まれているか
        retweeted_status = set_label('retweeted', retweeted) #リツイートであるか
        retweet_count = set_label('retweet_count', tweet.retweet_count) #リツイートされた回数
        retweeted_user = set_label('retweeted_user', retweeted_username) #リツイート元のユーザ名

        case @ary_type
        when 'simple'
            ary = [created_at, user_name, text]
        when 'numeric'
            ary = [created_at, user_id, tweet_id, retweet_count, friends_count, followers_count, all_tweet_count]
        when 'all'
            ary = [created_at, tweet_id, text, text_url, user_name, user_id, user_page, user_profile, prof_url, home_url, client, place_status, place, friends_count, followers_count, all_tweet_count, listed_count, url_status, retweeted_status, retweet_count, retweeted_user]
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