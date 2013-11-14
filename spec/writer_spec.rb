require  'writer'

describe Writer do

    after(:each) do
        system 'rm -rf ./tweet/test/*/*/*'
        system 'rm -f ./tweet/error/*test.txt'
        system 'rm -f ./tweet/id/test.txt'
    end

    describe 'initialize' do
        it 'はkeywordが入力されていないとエラー' do
            expect{Writer.new}.to raise_error(ArgumentError)
        end
    end

    describe 'get_dir_name' do
        it 'はyamlファイルからkeywordに対応したディレクトリ名と引数dir_nameが一致したときdir_nameを返す' do
            expect(Writer.new('テスト','test').dir_name).to eq('test')
        end
        it 'はyamlファイルからkeywordに対応したディレクトリ名を返す' do
            expect(Writer.new('テスト').dir_name).to eq('test')
        end
        it 'は与えられたdir_nameがyamlファイルの記述と異なる場合にエラーメッセージを返す' do
            expect{Writer.new('テスト','tets').dir_name}.to raise_error('yaml check')
        end
        it 'はyamlファイルにkeywordと対応したディレクトリ名がないとき、エラーメッセージを返す' do
            expect{Writer.new('トテス').dir_name}.to raise_error('yaml check')
        end
    end

    describe 'make_dir' do
        it 'はkeywordに対応したツイート保存用のディレクトリを作成する' do
            day = Time.now
            Writer.new('テスト').make_dir
            expect(FileTest.exist?("./tweet/test/#{day.year}/#{day.month}")).to eq(true)
        end
        it 'はkeywordに対応したエラーメッセージ保存用のディレクトリを作成する' do
            day = Time.now
            Writer.new('テスト').make_dir
            expect(FileTest.exist?("./tweet/error")).to eq(true)
        end
        it 'はkeywordに対応したツイートid保存用のディレクトリを作成する' do
            day = Time.now
            Writer.new('テスト').make_dir
            expect(FileTest.exist?("./tweet/id")).to eq(true)
        end
    end

    describe 'get_last_id' do
        it 'は最新のツイートのidを取得する' do
            expect(Writer.new('テスト').get_last_id).to eq(0)
        end
    end

    describe 'output_tweet' do
        it 'はツイートをファイルに出力する' do
            day = Time.now
            wdays = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
            Writer.new('テスト').output_tweet
            expect(FileTest.exist?("./tweet/test/#{day.year}/#{day.month}/#{day.year}-#{day.month}-#{day.day}-#{wdays[day.wday]}_test.ltsv")).to eq(true)
        end
    end

    describe 'output_error' do
        it 'はエラーメッセージをファイルに出力する' do
            day = Time.now
            wdays = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
            Writer.new('テスト').output_error
            expect(FileTest.exist?("./tweet/error/err_#{day.year}-#{day.month}-#{day.day}-#{wdays[day.wday]}_test.txt")).to eq(true)
        end
    end

    describe 'output_id' do
        it 'はツイートidをファイルに出力する' do
            Writer.new('テスト').output_id
            expect(FileTest.exist?("./tweet/id/test.txt")).to eq(true)
        end
    end

end