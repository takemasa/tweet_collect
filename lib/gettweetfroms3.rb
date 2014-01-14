class GetTweetFromS3

    def download(client, s3_filename)
        bucket = client.buckets["dsb-twitter"]
        bucket.objects.with_prefix(s3_filename).each do |filename|
            o = filename.key
            FileUtils.mkdir_p("./refine_search/#{File.dirname(o)}")
            bucket.objects[o].read {|chunk| File.open("./refine_search/#{o}", 'wb').write(chunk)}
        end
    end

    def file_exists?(files)
        failed_files = 0
        files.each do |file|
            failed_files += 1 if !file
        end
        "download failed #{failed_files} files"
    end
end
