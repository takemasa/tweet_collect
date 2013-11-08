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
        it 'はyamlファイルからkeywordに対応したdir名を返す' do
            expect(Writer.new('テスト').get_dir_name).to eq('test')
        end
        it 'はyamlファイルにkeywordに対応したdir名がないとき、エラーメッセージを返す' do
        	expect(Writer.new('テトス').get_dir_name).to eq('dir_name not exist in ./config/twkeyword.yaml')
        end
    end



end