require 'bundler/setup'
Bundler.require

class Compressor

    def initialize
        @old_files = get_old_filename
        @gzip_files = compress_file
    end
    attr_reader :old_files
    attr_reader :gzip_files

    def get_old_filename
        day = Time.now
        date = "#{day.year}-#{day.month}-#{day.day}"
        olds = []
        Dir.glob("./tweet/data/**/*.ltsv").each {|all_ltsv|
                olds << all_ltsv unless all_ltsv.include?(date)
        }
        olds
    end

    def compress_file
        gzips = []
        self.old_files.each{|filename|
            file = File.open(filename).read
            compress_file = "#{filename}.gz"
            gzips << compress_file
            Zlib::GzipWriter.open(compress_file) {|gz|
                gz.write file
            }
        }
        gzips
    end

    def delete_old_ltsv
        self.old_files.each{|of|
            system "rm -f #{of}"
        }
    end

end