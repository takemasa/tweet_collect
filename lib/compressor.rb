class Compressor

    def get_old_filename
        day = Time.now
        date = "#{day.year}-#{day.month}-#{day.day}"
        old = []

        # Dir.chdir("./tweet/data")
        Dir.glob("./tweet/data/**/*.ltsv").each {|all_ltsv|
                old << all_ltsv unless all_ltsv.include?(date)
        }
        old
    end

end