require  'cleaner'

describe Cleaner do
    describe 'get_retweeted' do
        it 'はリツイートされた元のテキストを返す' do
            expect(Writer.new('テスト').get_retweeted('RT: Hello World')).to eq('Hello World')
        end
    end

    describe 'set_text' do
        it 'はtweetの本文から改行文字とタブを削除して返す' do
            expect(Cleaner.new('テスト').clean_client(":Hello\n\tWorld")).to eq("Hello World")
        end
    end

    describe 'set_screen_name' do
        it 'はtweetのアカウント名からタブを削除して返す' do
            expect(Cleaner.new('テスト').clean_client()).to eq()
        end
    end

    describe 'set_client' do
        it 'はtweetのクライアント情報から不要な文字を削除して返す' do
            expect(Cleaner.new('テスト').clean_client("<a href=\"http://twtr.jp\" rel=\"nofollow\">Keitai Web</a>")).to eq("keitai web")
        end
    end

    describe 'set_label' do
        it 'はtweetの要素に、ラベルを付加して返す' do
            expect(Cleaner.new('テスト').clean_client(":12345")).to eq("tweet_id:12345")
        end
    end

    describe 'join_tweet_status' do
        it 'はtweetの要素をタブ区切りでつなげて返す' do
            expect(Cleaner.new('テスト').join_tweet_status()).to eq([])
        end
    end

    describe 'create_tweets_ary' do
        it 'は各ツイートを1つの配列にして返す' do
            expect(Cleaner.new.('テスト').create_tweets_ary()).to eq()
        end
    end
end