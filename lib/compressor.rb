require 'bundler/setup'
Bundler.require

class Compressor

    def get_old_filename
        day = Time.now
        date = "#{day.year}-#{day.month}-#{day.day}"
        old = []

        Dir.glob("./tweet/data/**/*.ltsv").each {|all_ltsv|
                old << all_ltsv unless all_ltsv.include?(date)
        }
        old
    end

    def compress_file(filenames)
        filenames.each{|filename|
            file = File.open(filename).read
            Zlib::GzipWriter.open("#{filename}.gz") {|gz|
                gz.write file
            }
        }
    end

end