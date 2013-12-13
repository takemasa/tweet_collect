require 'bundler/setup'
Bundler.require

class Compressor

    def initialize
        @old_files = get_old_filename_list
        @gzip_files = create_compress_list
    end
    attr_reader :old_files
    attr_reader :gzip_files

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

    def get_gzip_list
        gzips = []
        Dir.glob("./tweet/data/**/*.ltsv.gz").each {|all_gzip|
                gzips << all_gzip
        }
        gzips
    end
    private
    def create_compress_list
        gz_filenames = []
        @old_files.each{|of|
            gz_filenames << "#{of}.gz"
        }
        gz_filenames
    end

    def get_old_filename_list
        day = Time.now
        date = "#{day.year}-#{day.month}-#{day.day}"
        olds = []
        Dir.glob("./tweet/data/**/*.ltsv").each {|all_ltsv|
                olds << all_ltsv unless all_ltsv.include?(date)
        }
        olds
    end
end