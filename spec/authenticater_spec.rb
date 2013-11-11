require 'authenticater'

describe Authenticater do

  describe 'initialize' do
    it 'はaccount_idが入力されてないとエラー' do
      expect{Authenticater.new}.to raise_error(ArgumentError)
    end
  end

  describe 'get_access_key' do
    it 'はaccount_idが不正な値のときエラー' do
      expect(Authenticater.new('zero').tw_access_key).to eq('account_id not exist')
    end
    it 'はyamlファイルからアカウント情報を取得' do
      expect(Authenticater.new(0).tw_access_key).to eq({
        :consumer_key => 'dummy_consumer_key',
        :consumer_secret => 'dummy_consumer_secret',
        :oauth_token => 'dummy_oauth_token',
        :oauth_token_secret => 'dummy_oauth_token_secret'
      })
    end
  end
end