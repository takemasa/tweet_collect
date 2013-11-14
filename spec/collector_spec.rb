require 'collector'

describe Collector do

    describe 'initialize' do
        it 'はkeywordが入力されてないとエラー' do
            expect{Collector.new}.to raise_error(ArgumentError)
        end
    end

    describe 'search_tweet' do
        it 'はTwitterAPIのsearchを実行する' do
            m_client = double('twitter.search')
            m_search = double('search_result')

            m_client.should_receive(:search).with('keyword', :count=>100, :result_type => "recent", :since_id => 0, :lang => "ja").and_return(m_search)
            m_search.should_receive(:results).and_return(['results'])

            expect(Collector.new('keyword').search_tweet(m_client)).to eq(['results'])
        end
    end
end