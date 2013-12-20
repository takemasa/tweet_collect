require 'authenticater'

describe Authenticater do

  describe 'check_twaccount' do
    origin_name = File.expand_path(File.dirname(__FILE__) + '/../config/twaccount.yaml')
    tmp_name = File.expand_path(File.dirname(__FILE__) + '/../config/test_twaccount.yaml')

    before(:all) do
        File.rename(origin_name, tmp_name) if FileTest.exist?(origin_name)
    end
    after(:all) do
        File.rename(tmp_name, origin_name) if FileTest.exist?(tmp_name)
    end

    it 'はtwaccount.yamlが存在しないとき作成する' do
      expect{Authenticater.new}.to raise_error{'File not found'}
    end
  end

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

  describe 'get_twitter_client' do
    it 'はアカウント情報がnilのときエラーを返す' do
      expect{Authenticater.new.get_twitter_client}.to raise_error 'account not exist'
    end
  end


  describe 'aws_authenticate' do

    origin_name = File.expand_path(File.dirname(__FILE__) + '/../config/aws.yaml')
    tmp_name = File.expand_path(File.dirname(__FILE__) + '/../config/test_aws.yaml')

    before(:all) do
        File.rename(origin_name, tmp_name) if FileTest.exist?(origin_name)
    end
    after(:all) do
        File.rename(tmp_name, origin_name) if FileTest.exist?(tmp_name)
    end

    describe 'check_awsacconut' do
      it 'はaws.yamlが存在しないとき作成する' do
        expect{Authenticater.new}.to raise_error{'File not found'}
      end
    end

    describe 'get_aws_client' do
      it 'はawsキー情報がnilのときエラーを返す' do
        expect{Authenticater.new.get_aws_client}.to raise_error{'no credentials'}
      end
    end
  end
end