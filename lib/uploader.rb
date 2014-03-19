require 'bundler/setup'
Bundler.require

class Uploader

    def initialize(local_gzfile, bucketname)
        @directory = get_dir(local_gzfile)
        @bucketname = bucketname
    end
    attr_reader :directory

    def get_dir(local_gzfile)
        dir = local_gzfile.gsub("./tweet/data/", "")
        return File.dirname("#{@bucketname}/#{dir}")
    end

    def upload(client, local_gzfile)
            client.buckets[@directory].objects[File.basename(local_gzfile)].write(:file => local_gzfile)
    end
end
