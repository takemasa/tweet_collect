require File.expand_path(File.dirname(__FILE__) + '/converter.rb')

class Parser

    def initialize(filenames)
        @results = []
        @line_count = 0
        filenames.each do |filename|
            if FileTest.exist?("./refine_search/#{filename}") == true
                puts "read #{filename}"
            else
                raise 'File not exists'
            end
            @newfilename = "#{File.basename(filename, ".ltsv")}"
            file = filename.include?('.gz') ? Zlib::GzipReader : File
            file.open("./refine_search/#{filename}").each_line do |line|
                @results << LTSV.parse(line)
                @line_count += 1
                write if @line_count % 10000 == 0
            end
            write if @results
        end
        puts @line_count
    end
    attr_reader :hash_list
    attr_reader :csv_text

    def write
        @hash_list = quotation(spread)
        @csv_text = sort
        puts "#{@hash_list[:created_at][-1]}: #{@hash_list[:text][-1]}"
        File.open("./refine_search/#{@newfilename}.csv", 'a+'){ |f| f.puts @csv_text }
        @results = []
    end

    def spread
        hash_list = {}
        @results.each_with_index do |list, i|
            list[0].keys.each do |l|
                hash_list[l] = [] unless hash_list[l]
                hash_list[l][i] = list[0][l]
            end
        end
        hash_list
    end

    def quotation(hash_list)
        hash_list.each do |key, value|
            value.each_with_index do |val, i|
                val = val.gsub('"', '^^').gsub(',','&&').gsub(/(\r\n|\r|\n|\t|,)/," ") if val
                hash_list[key][i] = "\"#{val}\""
            end
        end
        hash_list
    end

    def sort
        values = @hash_list.values
        lines = values[0].length
        ary = []
        lines.times do |l|
            values.each do |value|
                ary << "#{value[l]},"
            end
            ary << "\n"
        end
        ary.join
    end
end
