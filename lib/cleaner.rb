class Cleaner

    def initialize(ary_type = nil)
        raise 'ary_type needed' unless ary_type
        @ary_type = ary_type
    end

    def modify_tweet_status_str(tweet_text)
        tweet_text.gsub(/(\r\n|\r|\n|\t|:|,)/," ")
    end

    def modify_twitter_client_str(twitter_client)
        twitter_client.gsub(/(<.*">|<\/a>|\r\n|\r|\n|\t)/,"").gsub(","," ")
    end

    def modify_place(place = nil)
        place ? [true, place.full_name] : [false, ""]
    end

    def modify_urls(tweet)
        urls = []
        tweet[:urls].each do |url|
            urls << url[:expanded_url]
        end
        urls.join(' , ')
    end

    def retweeted_status(retweeted)
        retweeted ? [true, retweeted.user.screen_name, retweeted.user.id] : [false, nil, nil]
    end

    def favorite_status(tweet, retweeted)
        retweeted ? retweeted.favorite_count : tweet.favorite_count
    end

    def set_label(labels, tweet_status)
        lists = {}
        labels.each_with_index do |label, i|
            lists[label] = "#{label}:#{tweet_status[i]}"
        end
        lists
    end

    def create_ary_tweet (tweet)
        text_urls = tweet.attrs[:entities][:urls].empty? ? nil : modify_urls(tweet.attrs[:entities])
        prof_urls = tweet.attrs[:user][:entities][:description][:urls].empty? ? nil : modify_urls(tweet.attrs[:user][:entities][:description])
        home_urls = tweet.attrs[:user][:entities][:url] ? modify_urls(tweet.attrs[:user][:entities][:url]) : nil# ホームページのリンクが存在しない時は[:url]のハッシュが作られないため、空の配列を代入する
        url = prof_urls && home_urls ? false : true
        retweet = retweeted_status(tweet.retweeted_status)
        tweet_place = modify_place(tweet.place)
        favorite = favorite_status(tweet, tweet.retweeted_status)

        labels = [
            'created_at',
            'tweet_id',
            'tweet_page',
            'text',
            'text_url',
            'user_name',
            'user_id',
            'user_page',
            'profile',
            'prof_url',
            'home_url',
            'client',
            'place_status',
            'place',
            'friends_count',
            'followers_count',
            'all_tweet_count',
            'listed_count',
            'url_status',
            'retweeted_status',
            'retweet_count',
            'retweeted_user',
            'retweeted_user_id',
            'favorite_count'
        ]


        tweet_status = [
            tweet.created_at,
            tweet.id, #ツイートID
            "https://twitter.com/#{tweet.user.screen_name}/status/#{tweet.id}",
            modify_tweet_status_str(tweet.full_text), #ツイート本文
            text_urls, #ツイートのURL
            tweet.user.screen_name, #ツイートしたユーザ名
            tweet.user.id, #ユーザID
            "https://twitter.com/intent/user?user_id=#{tweet.user.id}", #ユーザーページのURL
            modify_tweet_status_str(tweet.user.description), #ユーザのプロフィール
            prof_urls, #プロフィール文のURL
            home_urls, #プロフィールのURL欄
            modify_twitter_client_str(tweet.source), #ツイート時に使用したクライアント
            tweet_place[0], #位置情報の有無
            tweet_place[1], #位置情報
            tweet.user.friends_count, #フォロー数
            tweet.user.followers_count, #フォロワー数
            tweet.user.statuses_count, #総ツイート数
            tweet.user.listed_count, #リストに加えられている数
            url, # ツイート情報にURLが含まれているか
            retweet[0], #リツイートであるか
            tweet.retweet_count, #リツイートされた回数
            retweet[1],#リツイート元のユーザ名
            retweet[2],#リツイート元のユーザID
            favorite
        ]

        tweet = set_label(labels, tweet_status)

        case @ary_type
        when 'simple'
            ary = [tweet['created_at'], tweet['user_name'], tweet['text']]
        when 'numeric'
            ary = [tweet['created_at'], tweet['user_id'], tweet['tweet_id'], tweet['retweet_count'], tweet['friends_count'], tweet['followers_count'], tweet['all_tweet_count']]
        when 'all'
            ary = [tweet['created_at'], tweet['tweet_id'], tweet['tweet_page'], tweet['text'], tweet['text_url'], tweet['user_name'], tweet['user_id'], tweet['user_page'], tweet['profile'], tweet['prof_url'], tweet['home_url'], tweet['client'], tweet['place_status'], tweet['place'], tweet['friends_count'], tweet['followers_count'], tweet['all_tweet_count'], tweet['listed_count'], tweet['url_status'], tweet['retweeted_status'], tweet['retweet_count'], tweet['retweeted_user'], tweet['retweeted_user_id'], tweet['favorite_count']]
        end
        ary
    end

    def join_tweet_status(tweet)
        tweet.join("\t")
    end
end