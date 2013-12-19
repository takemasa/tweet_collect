require  'cleaner'

describe Cleaner do
    describe 'initialize' do
        it 'はary_typeがないときエラー' do
            expect{Cleaner.new}.to raise_error('ary_type needed')
        end
    end
    describe 'get_retweeted' do
        it 'はリツイートされていた場合元のツイート本文にRTをつけて返す' do
            expect(Cleaner.new('simple').get_retweeted('Hello World')).to eq('RT Hello World')
        end
        it 'はリツイートされていなければ何もしない' do
            expect(Cleaner.new('simple').get_retweeted(nil)).to eq(nil)
        end
    end

    describe 'modify_tweet_status_str' do
        it 'は文字列から改行文字とタブと:を削除して返す' do
            expect(Cleaner.new('simple').modify_tweet_status_str(":Hello\nworld\t")).to eq("Hello world ")
        end
    end

    describe 'modify_twitter_client_str' do
        it 'はtweetのクライアント情報からクライアント名以外を削除して返す' do
            expect(Cleaner.new('simple').modify_twitter_client_str("<a href=\"http://twtr.jp\" rel=\"nofollow\">Keitai Web</a>")).to eq("Keitai Web")
        end
    end

    describe 'join_tweet_status' do
        it 'はtweetの要素をタブ区切りでつなげて返す' do
            expect(Cleaner.new('simple').join_tweet_status([
                "created_at:2013-11-13 08:02:56 +0900",
                "text:Hello,world"
                ])).to eq(
                "created_at:2013-11-13 08:02:56 +0900\ttext:Hello,world")
        end
    end

    describe 'add_tweets_ary' do
        it 'は各ツイートを1つの配列にして返す' do
            expect(Cleaner.new('simple').add_tweets_ary("tweet")).to eq(["tweet"])
        end
    end
end