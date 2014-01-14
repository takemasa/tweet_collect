require 'gettweetfroms3'

describe 'gettweetfroms3' do

    GTF = GetTweetFromS3.new
    describe 'download' do
        it 'はファイルをダウンロードする' do
            m_buckets = double('buckets')
            m_objects = double('objects')
            m_download = double('download')
            m_dir = double('dir')
            m_file = double('file')
            m_prefix = double('prefix')

            m_buckets.should_receive(:buckets).and_return(m_dir)
            m_dir.should_receive(:[]).and_return(m_objects)
            m_objects.should_receive(:objects).and_return(m_prefix)
            m_prefix.should_receive(:with_prefix).and_return(m_file)
            m_file.should_receive(:each).and_return(['results'])

            expect(GTF.download(m_buckets, 'dsb-twitter/eki')).to eq(['results'])
        end
    end

    describe 'file_downloaded?' do
        it 'は指定期間のファイルがダウンロードできなかったときにエラーを返す' do
            expect(GTF.file_exists?(["lib/gettweetfroms3.test", nil])).to eq('download failed 1 files')
        end
    end
end