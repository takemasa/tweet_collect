require 'compressor.rb'
require 'authenticater.rb'
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

    def upload(client, file_name)
            client.buckets(File.dirname(file_name)).objects(file_name).write(:file => file_name)
    end
end
