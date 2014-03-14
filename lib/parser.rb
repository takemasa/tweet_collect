require File.expand_path(File.dirname(__FILE__) + '/converter.rb')

class Parser

    def initialize(filenames)
        @hash_list = quotation(Converter.new(filenames, uniq = false, follower_limit = 0).hash_list)
        @csv_text = sort
    end
    attr_reader :hash_list
    attr_reader :csv_text

    def quotation(hash_list)
        hash_list.each do |key, value|
            value.each_with_index do |val, i|
                val = val.gsub('"', '^^').gsub(',','&&').gsub(/(\r\n|\r|\n|\t|:|,)/," ") if val
                hash_list[key][i] = "\"#{val}\""
            end
        end
        hash_list
    end

    def sort
        keys = @hash_list.keys
        values = @hash_list.values
        lines = values[0].length
        ary = []
        lines.times do |l|
            values.each do |value|
                ary << "#{value[l]},"
            end
            ary << "\n"
        end
        puts "sort by: "
        puts keys
        ary.join
    end

    def write(newfilename)
        puts newfilename = "#{newfilename}.csv" unless newfilename[-4..-1] == '.csv'
        File.open("./refine_search/#{newfilename}", 'w'){ |f| f.puts @csv_text }
    end
end
