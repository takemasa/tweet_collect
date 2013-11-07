require 'collection'

describe Collector do
  after(:each) do
    system 'rm -rf ./tweet/*'
  end

  describe 'file' do

    it 'はREST APIにアクセスする' do
      rest = double('keyword')
      rest.should_receive(:search_tw).and_return('success')
      collector = Collector.new(rest)
      expect(collector.file(@keyword)).to eq('status success')
    end
  end
end