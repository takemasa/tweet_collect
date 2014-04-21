# extract_transform内の.gzファイルを変換
require_relative '../lib/authenticater.rb'
require_relative '../lib/getrefinesearchconfig.rb'
require_relative '../lib/gettweetfroms3.rb'
require_relative '../lib/parser_tmp.rb'
require_relative '../lib/compressor.rb'
require_relative '../lib/uploader.rb'
require 'bundler/setup'
Bundler.require(:report)
require 'date'
Dotenv.load

t0 = Time.now
(Date.parse("2014/03/09")..Date.parse("2014/04/21")).each {|restday|
    # 前日分ファイルをS3からダウンロード
    restday = (Date.today-1).to_s
    year = restday[0, 4]
    month = restday[5, 2]
    client = Authenticater.new.get_aws_client
    keywordtags = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "/../config/twkeyword.yaml"))
    files = []
    keywordtags.each do |tag|
        puts "get #{tag[1]}/#{year}/#{month}/#{restday}*.ltsv.gz"
        file = "#{tag[1]}/#{year}/#{month}/#{restday}"
        files << GetTweetFromS3.new('./extract_transform').download(client, file) unless GetTweetFromS3.new('./extract_transform').avoid_duplication(file)
    end
    puts GetTweetFromS3.new('./extract_transform').file_exists?(files)

    # ダウンロードしたファイルをcsvへ変換
    filenames = []
    Dir.glob("./extract_transform/**/*.ltsv.gz").each do |file|
        filenames << file
    end
    Parser.new(filenames)

    # csvをgzip圧縮
    dir, extension, bucketname = "./extract_transform", "csv", "dsb-twitter-csv"
    compressor = Compressor.new(dir, extension)
    compressor.compress_file

    # csvをS3へアップロードし、ローカルファイルを削除
    convert_filenames = compressor.get_gzip_list
    convert_filenames.each{|gzfile| Uploader.new(gzfile, bucketname).upload(client, gzfile)}
    compressor.delete_old_files
    compressor.delete_old_gzip
    compressor = Compressor.new(dir, 'ltsv')
    compressor.delete_old_gzip

    # S3のcsvをRedshiftに格納
    convert_filenames.each do |convert_filename|
        if convert_filename
            convert_filename = convert_filename.gsub('./extract_transform/', '')
            sql = "COPY twitter.tweetdata FROM 's3://dsb-twitter-csv/#{convert_filename}' CREDENTIALS 'aws_access_key_id=#{ENV['AccessKeyId']};aws_secret_access_key=#{ENV['SecretAccessKey']}' DELIMITER ',' GZIP REMOVEQUOTES;"

            cmd = "psql -h val-dwh.ckmoj1esntau.ap-northeast-1.redshift.amazonaws.com -p 5439 -U twuser -d logdb -c \"#{sql}\""
            systemu cmd
        end
    end
}
t1 = Time.now
puts  "Process Time: #{t1 - t0} sec"
