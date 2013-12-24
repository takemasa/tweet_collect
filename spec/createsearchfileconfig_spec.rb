require 'createsearchfileconfig'

describe 'createsearchfileconfig' do

    describe 'get_keyword' do
        it 'はキーワードを返す' do
            expect(CreateSearchFileConfig.new.get_keyword).to eq(['eki','densha','chien'])
        end
    end

    describe 'create_filepath' do

        origin_file = File.expand_path(File.dirname(__FILE__) + '/../config/search_config.yaml')
        tmp_file = File.expand_path(File.dirname(__FILE__) + '/../config/tmp_search_config.yaml')
        sample_file = File.expand_path(File.dirname(__FILE__) + '/../config/search_config.yaml.sample')

        before(:all) do
            File.rename(origin_file, tmp_file)
            File.rename(sample_file, origin_file)
        end
        after(:all) do
            File.rename(origin_file, sample_file)
            File.rename(tmp_file, origin_file)
        end

        it 'は絞り込み検索をしたいファイルの場所を返す' do
            expect(CreateSearchFileConfig.new.create_filepath).to eq(
                ["dsb-twitter/eki/2013/12/2013-12-06",
                    "dsb-twitter/densha/2013/12/2013-12-06",
                    "dsb-twitter/chien/2013/12/2013-12-06",
                    "dsb-twitter/eki/2013/12/2013-12-07",
                    "dsb-twitter/densha/2013/12/2013-12-07",
                    "dsb-twitter/chien/2013/12/2013-12-07",
                    "dsb-twitter/eki/2013/12/2013-12-08",
                    "dsb-twitter/densha/2013/12/2013-12-08",
                    "dsb-twitter/chien/2013/12/2013-12-08"])
        end
    end
end
