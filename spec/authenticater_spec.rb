require 'authenticater'

describe Authenticater do

  describe 'get_access_key' do
    it 'はaccount_idが空のとき、nilを返す' do
      expect(Authenticater.new.tw_key).to eq(nil)
    end
    it 'はyamlファイルからtwitterアカウント情報を取得' do
      expect(Authenticater.new('dummy').tw_key).to eq({
        :consumer_key => 'dummy_consumer_key',
        :consumer_secret => 'dummy_consumer_secret',
        :oauth_token => 'dummy_oauth_token',
        :oauth_token_secret => 'dummy_oauth_token_secret'
      })
    end
  end
end