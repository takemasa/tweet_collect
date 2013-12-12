require 'compressor'

describe Compressor do

    after(:each) do
        system "rm -f ./tweet/data/test/*"
    end

    filename = "./tweet/data/test/#{Time.now.year}/#{Time.now.month}/#{Time.now.year}-#{Time.now.month}-#{Time.now.day-1}_test.ltsv"

    describe 'get_old_filename' do
        it 'は現在時刻がファイル名に含まれないファイrの一覧を取得' do
            File.open("#{filename}",'a+')
            expect(Compressor.new.get_old_filename).to eq([filename])
        end
    end

end