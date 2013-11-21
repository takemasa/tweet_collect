require  'cleaner'

describe Cleaner do
    describe 'get_retweeted' do
        it 'はリツイートされていた場合元のツイート本文にRTをつけて返す' do
            expect(Cleaner.new.get_retweeted('Hello World')).to eq('RT Hello World')
        end
        it 'はリツイートされていなければ何もしない' do
            expect(Cleaner.new.get_retweeted(nil)).to eq(nil)
        end
    end

    describe 'modify_tweet_status_str' do
        it 'は文字列から改行文字とタブと:を削除して返す' do
            expect(Cleaner.new.modify_tweet_status_str(":Hello\nworld\t")).to eq("Hello world ")
        end
    end

    describe 'modify_twitter_client_str' do
        it 'はtweetのクライアント情報からクライアント名以外を削除して返す' do
            expect(Cleaner.new.modify_twitter_client_str("<a href=\"http://twtr.jp\" rel=\"nofollow\">Keitai Web</a>")).to eq("Keitai Web")
        end
    end

    describe 'set_label' do
        it 'はtweetの要素に、ラベルを付加して返す' do
            expect(Cleaner.new.set_label("tweet_id:", "12345")).to eq("tweet_id:12345")
        end
    end
    describe 'join_tweet_status' do
        it 'はtweetの要素をタブ区切りでつなげて返す' do
            expect(Cleaner.new.join_tweet_status([
                "created_at:2013-11-13 08:02:56 +0900",
                "text:Hello,world",
                "tweet_id:12345",
                "screen_name:screen_name",
                "friends_count:0",
                "followers_count:0",
                "retweet_count:0",
                "user.id:0",
                "place:0",
                "all_tweets_count:1",
                "client:keitai web"
                ])).to eq(
                "created_at:2013-11-13 08:02:56 +0900\ttext:Hello,world\ttweet_id:12345\tscreen_name:screen_name\tfriends_count:0\tfollowers_count:0\tretweet_count:0\tuser.id:0\tplace:0\tall_tweets_count:1\tclient:keitai web")
        end
    end

    describe 'add_tweets_ary' do
        it 'は各ツイートを1つの配列にして返す' do
            expect(Cleaner.new.add_tweets_ary("tweet")).to eq(["tweet"])
        end
    end
end