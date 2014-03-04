require  'cleaner'

describe Cleaner do
    describe 'initialize' do
        it 'はary_typeがないときエラー' do
            expect{Cleaner.new}.to raise_error('ary_type needed')
        end
    end


    describe 'modify_tweet_status_str' do
        it 'は文字列から改行文字とタブと:と,を削除して返す' do
            expect(Cleaner.new('simple').modify_tweet_status_str(":Hello,\nworld\t")).to eq(" Hello  world ")
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

    describe 'set_label' do
        it 'は配列をハッシュに格納' do
            labels = ['created_at', 'tweet_id', 'text', 'url', 'name', 'user_id', 'home_url', 'profile', 'prof_url']
            tweets_status = ["2014-03-04 16:58:40 +0900", '000000001', 'text', '', 'me', '001', '', 'profile', '']
            expect(Cleaner.new('simple').set_label(labels, tweets_status)).to eq({"created_at"=>"created_at:2014-03-04 16:58:40 +0900", "tweet_id"=>"tweet_id:000000001", "text"=>"text:text", "url"=>"url:", "name"=>"name:me", "user_id"=>"user_id:001", "home_url"=>"home_url:", "profile"=>"profile:profile", "prof_url"=>"prof_url:"})
        end
    end
end