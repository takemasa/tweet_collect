require 'compressor.rb'
require 'authenticater.rb'
require 'bundler/setup'
Bundler.require

class Uploder

    def initialize(gzfile)
        @directory = get_dir(gzfile)
    end
    attr_reader :directory

    def get_dir(gzfile)
        dir = gzfile.gsub("./tweet/data/", "")
        return "dsb-twitter/#{dir}"
    end

    def upload(client, file_name)
            client.buckets(File.dirname(file_name)).objects(file_name).write(:file => file_name)
    end
end