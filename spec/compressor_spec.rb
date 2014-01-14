require 'compressor'

describe Compressor do

    after(:all) do
        FileUtils.remove_dir("./tweet/data/test")
    end

    FileUtils.mkdir_p("./tweet/data/test/#{Time.now.year}/#{Time.now.strftime("%m")}")
    wdays = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
    Time.now.day-1 < 10 ? day = "0#{Time.now.day-1}" : day = Time.now.day-1
    old_filename = "./tweet/data/test/#{Time.now.year}/#{Time.now.strftime("%m")}/#{Time.now.year}-#{Time.now.strftime("%m-#{day}-")}#{wdays[Time.now.wday-1]}_test.ltsv"
    new_filename = "./tweet/data/test/#{Time.now.year}/#{Time.now.strftime("%m")}/#{Time.now.year}-#{Time.now.strftime("%m-%d-")}#{wdays[Time.now.wday]}_test.ltsv"
    File.open("#{old_filename}",'a+')
    File.open("#{new_filename}",'a+')


    describe 'get_old_filename_list' do
        it 'は現在の日付がファイル名に含まれないファイルの一覧を取得' do
            expect(Compressor.new.old_files).to eq([old_filename])
        end
    end

    describe 'compress_file' do
        it '受け取ったファイル名に基づいてファイルをgzip圧縮する' do
            Compressor.new.compress_file
            expect(FileTest.exist?("#{old_filename}.gz")).to eq(true)
        end
    end

    describe 'get_gzip_list' do
        it 'は存在するgzipファイルを取得' do
            expect(Compressor.new.get_gzip_list).to eq(["#{old_filename}.gz"])
        end
    end

end