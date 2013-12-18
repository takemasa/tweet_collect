require 'uploder'

describe Uploder do

    after(:all) do
        system 'rm -f ./tweet/data/test/*/*/*'
    end

    wdays = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
    old_filename = "./tweet/data/test/#{Time.now.year}/#{Time.now.month}/#{Time.now.year}-#{Time.now.month}-#{Time.now.day-1}-#{wdays[Time.now.wday]}_test.ltsv.gz"
    new_filename = "./tweet/data/test/#{Time.now.year}/#{Time.now.month}/#{Time.now.year}-#{Time.now.month}-#{Time.now.day}-#{wdays[Time.now.wday]}_test.ltsv.gz"

    File.open("#{old_filename}",'a+')
    File.open("#{new_filename}",'a+')

    describe 'get_dir' do
        it 'はファイルのアップロード先を返す' do
            expect(Uploder.new(old_filename).get_dir(old_filename)).to eq("dsb-twitter/test/#{Time.now.year}/#{Time.now.month}/#{File.basename(old_filename)}")
        end
    end

    describe 'upload' do
        it 'はファイルをs3にアップロードする' do
            m_buckets = double('buckets')
            m_objects = double('objects')
            m_upload = double('upload')

            m_buckets.should_receive(:buckets).and_return(m_objects)
            m_objects.should_receive(:objects).and_return(m_upload)
            m_upload.should_receive(:write).with({:file => "dirname"}).and_return(['results'])

            expect(Uploder.new(old_filename).upload(m_buckets, "dirname")).to eq(['results'])
        end
    end
end