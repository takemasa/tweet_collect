require 'collector'

describe Collector do

    describe 'initialize' do
        it 'はkeywordが入力されてないとエラー' do
            expect{Collector.new}.to raise_error(ArgumentError)
        end
        it 'はsince_idが存在しないとき0を代入' do
            expect(Collector.new('駅').since_id).to eq(0)
        end
    end

    describe 'get_since_id' do
        it 'は最新のツイートidが存在しないとき0を返す' do
            expect(Collector.new('テスト').get_since_id).to eq(0)
        end
    end

    describe 'search_tweet' do
        it 'はTwitterAPIのsearchを実行する' do
            m_client = double('twitter.search')
            m_search = double('search_result')

            m_client.should_receive(:search).with('テスト', :count=>100, :result_type => "recent", :since_id => 0, :lang => "ja").and_return(m_search)
            m_search.should_receive(:results).and_return(['results'])

            expect(Collector.new('テスト').search_tweet(m_client)).to eq(['results'])
        end
    end
end