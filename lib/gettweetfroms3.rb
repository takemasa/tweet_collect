class GetTweetFromS3
    def initialize(filepath)
        @filename = filepath
    end

    def download(client, s3_filename)
        bucket = client.buckets["dsb-twitter"]
        bucket.objects.with_prefix(s3_filename).each do |filename|
            o = filename.key
            FileUtils.mkdir_p("./refine_search/#{File.dirname(o)}")
            bucket.objects[o].read {|chunk| File.open("./refine_search/#{o}", 'wb').write(chunk)}
        end
    end

    def file_downloaded?
        file_status, failed_file_name =false, nil
        @filename.each do |file|
            file_status, failed_file_name = false, file unless File.exists?(file)
        end
        raise "download failed :#{failed_file_name}" unless file_status
    end
end
