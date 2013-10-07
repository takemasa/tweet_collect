require 'collection'

describe Collector do
  after(:each) do
    system 'rm -rf ./tweet/*'
  end
  describe "searchメソッド" do
  	it 'は、キーワードを指定した場合、一致するツイートを取得する' do
  		Collector.new("なう").search
  		expect(FileTest.exist?("./tweet/now/*_now.csv")).to eq(true)
  	end
  end
end