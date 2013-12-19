require 'bundler/setup'
Bundler.require

class Uploader

    def initialize(local_gzfile)
        @directory = get_dir(local_gzfile)
    end
    attr_reader :directory

    def get_dir(local_gzfile)
        dir = local_gzfile.gsub("./tweet/data/", "")
        return File.dirname("dsb-twitter/#{dir}")
    end

    def upload(client, local_gzfile)
            client.buckets[@directory].objects[File.basename(local_gzfile)].write(:file => local_gzfile)
    end
end
