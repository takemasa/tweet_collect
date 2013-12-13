require 'compressor'

describe Compressor do

    wdays = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
    old_filename = "./tweet/data/test/#{Time.now.year}/#{Time.now.month}/#{Time.now.year}-#{Time.now.month}-#{Time.now.day-1}-#{wdays[Time.now.wday]}_test.ltsv"
    new_filename = "./tweet/data/test/#{Time.now.year}/#{Time.now.month}/#{Time.now.year}-#{Time.now.month}-#{Time.now.day}-#{wdays[Time.now.wday]}_test.ltsv"

    File.open("#{old_filename}",'a+')
    File.open("#{new_filename}",'a+')


    describe 'get_old_filename_list' do
        it 'は現在の日付がファイル名に含まれないファイrの一覧を取得' do
            expect(Compressor.new.old_files).to eq([old_filename])
        end
    end

    describe 'create_compress_list' do
        it 'は作成する圧縮ファイル名を返す' do
            expect(Compressor.new.gzip_files).to eq(["#{old_filename}.gz"])
        end
    end

    describe 'compress_file' do
        it '受け取ったファイル名に基づいてファイルをgzip圧縮する' do
            Compressor.new.compress_file
            expect(FileTest.exist?("#{old_filename}.gz")).to eq(true)
        end
    end

    describe 'delete_old_ltsv' do
        it 'は日付が今日でないltsvファイルを削除' do
            Compressor.new.delete_old_ltsv
            expect(FileTest.exist?("#{old_filename}")).to eq(false)
        end
    end

    describe 'get_gzip_list' do
        it 'は存在するgzipファイルを取得' do
            expect(Compressor.new.get_gzip_list).to eq(["#{old_filename}.gz"])
        end
    end

    describe 'delete_gzip' do
        it 'は作成した圧縮ファイルを削除' do
            Compressor.new.delete_old_gzip
            expect(FileTest.exist?("#{old_filename}.gz")).to eq(false)
        end
    end

end