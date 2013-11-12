require  'writer'

describe Writer do

    after(:each) do
        system 'rm -rf ./tweet/test'
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
        it 'はyamlファイルにkeywordに対応したディレクトリ名がないとき、エラーメッセージを返す' do
        	expect(Writer.new('トテス').get_dir_name(keyword)).to eq('dir_name not exist in ./config/twkeyword.yaml')
        end
        it 'はyamlファイルにkeywordに対応したディレクトリ名がなく、dir_nameが存在するとき、dir_nameを返す' do
            expect(Writer.new('トテス','ttes').dir_name).to eq('ttes')
        end
        it 'は与えられたdir_nameがyamlファイルの記述と異なる場合にエラーメッセージを返す' do
            expect(Writer.new('テスト','tets').dir_name).to eq('dir_name :test')
        end
    end

    describe 'make_dir' do
        it 'はkeywordに対応したディレクトリを作成する' do
            Writer.new('テスト').make_dir
            expect(FileTest.exist?("./tweet/test")).to eq(true)
        end
        it 'はdir_nameに応じてディレクトリを作成' do
            Writer.new('テトス','tets').make_dir
            expect(FileTest.exist?("./tweet/tets")).to eq(true)
        end
    end

    describe 'get_filename' do
        it 'はtweetを出力するファイル名を取得する' do
            m_filename = double('filename')
            m_filename.should_receive(:get_filename).with('テスト').and_return('filename')
            expect(Writer.new('テスト').get_filename).to eq('filename')
        end
    end

    describe 'get_retweeted' do
        it 'はリツイートされたもとのテキストを返す' do
            expect(Writer.new('テスト').get_retweeted('RT: Hello World')).to eq('Hello World')
        end
    end

    describe 'output_file' do
        it 'はtweetをテキストに出力する' do
            Writer.new('テスト').output_file
            expect(FileTest.exist?("./tweet/test/#{filename}.ltsv")).to eq(true)
        end
    end
end