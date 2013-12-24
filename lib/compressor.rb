require 'bundler/setup'
Bundler.require

class Compressor

    def initialize
        @old_files = get_old_filename_list
    end
    attr_reader :old_files

    def compress_file
        @old_files.each{|filename|
            file = File.open(filename).read
                Zlib::GzipWriter.open("#{filename}.gz") do |gz| gz.write file end
        }
    end

    def delete_old_ltsv
        @old_files.each{|of|
            File.delete(of)
        }
    end

    def delete_old_gzip
        self.get_gzip_list.each{|gf|
            File.delete(gf)
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