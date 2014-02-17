class GetTweetFromS3

    def avoid_duplication(s3filename)
        exist = false
        Dir.glob("./refine_search/#{File.dirname(s3filename)}/*"){|all_file|
            File.basename(all_file).include?(File.basename(s3filename)) ? exist = true : exist = false
            break if exist
        }
        exist
    end

    def download(client, s3_filename)
        bucket = client.buckets["dsb-twitter"]
        bucket.objects.with_prefix(s3_filename).each do |filename|
            o = filename.key
            FileUtils.mkdir_p("./refine_search/#{File.dirname(o)}")
            File.open("./refine_search/#{o}", 'wb') do |file|
                object = bucket.objects[o]
                object.read {|chunk| file.write(chunk)}
            end
            return o
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
