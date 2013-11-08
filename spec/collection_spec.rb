require 'collection'

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
      m_results = double('tweets')

      m_client.should_receive(:search).with('keyword', :count=>100, :result_type => "recent", :since_id => 0, :lang => "ja").and_return(m_search)
      m_search.should_receive(:results).and_return([m_results])
      # results.should_receive(:text).and_return('tweet text')

      expect(Collector.new('keyword').search_tweet(m_client)).to eq(m_results)
    end
  end
end

describe Authenticate do

  describe 'initialize' do
    it 'はaccount_numが入力されてないとエラー' do
      expect{Authenticate.new}.to raise_error(ArgumentError)
    end
  end

  describe 'tw_config' do

    it 'はaccount_numが不正な値のときエラー' do
      expect(Authenticate.new('zero').twconfig(@account_num)).to eq('account_num not exist')
    end
    it 'はtwitterへのOAuth認証を実行する' do
      m_oauth = double('OAuth')
      m_oauth.should_receive(:new).with(
        :consumer_key => 'dummy_consumer_key',
        :consumer_secret => 'dummy_consumer_secret',
        :oauth_token => 'dummy_oauth_token',
        :oauth_token_secret => 'dummy_oauth_token_secret'
        ).and_return('OAuth OK')
      expect(Authenticate.new(0).twconfig(m_oauth)).to eq('OAuth OK')
    end
  end
end

describe Writer do

  describe 'last_id' do
    it 'は最新のツイートのidを取得する' do
      writer = Writer.new('test')
      expect(writer.last_id).to eq(9999)
    end
  end
end

