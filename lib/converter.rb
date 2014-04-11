require 'bundler/setup'
Bundler.require

class Converter

    def initialize(filenames, uniq, follower_limit = nil)
        @results = []
        @account_ids = []
        @tweet_ids = []
        @filted_count = 0
        @line_count = 0
        filenames.each do |filename|
            if FileTest.exist?("./refine_search/#{filename}") == true
                puts "read #{filename}"
            else
                raise 'File not exists'
            end
            if filename.include?('.gz')
                Zlib::GzipReader.open("./refine_search/#{filename}").each_line do |line|
                    check_ids(line, uniq, follower_limit)
                    @line_count += 1
                    # raise 'Too long data!' if @line_count - @filted_count > 65535
                end
            else
                File.open("./refine_search/#{filename}").each_line do |line|
                    check_ids(line, uniq, follower_limit)
                    @line_count += 1
                    # raise 'Too long data!' if @line_count - @filted_count > 65535
                end
            end
        end
        @hash_list = spread
        puts "#{@line_count - @filted_count} / #{@line_count}"
    end
    attr_reader :hash_list

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

    def filt_follower(line, follower_limit)
        if follower_limit
            limit = true if line[0][:followers_count].to_i >= follower_limit.to_i
        else
            limit = true
        end
        unless limit
            puts "---------------------------------" if (@line_count + 1) % 10000 == 0
            @filted_count += 1
        end
        return limit ? line : nil
    end


    def check_ids(line, uniq, follower_limit)
        if line != "\n"
            elems = filt_follower(LTSV.parse(line), follower_limit)
        end
        if elems
            account_id = elems[0][:user_id].to_i
            tweet_id = elems[0][:tweet_id].to_i
        else
            return
        end
        if uniq == "uniq" && account_id_index = @account_ids.index(account_id)
            set_elems(tweet_id, account_id_index, elems)
            puts "#{elems[0][:created_at]} / #{elems[0][:followers_count]} / #{elems[0][:text]}" if (@line_count + 1) % 10000 == 0
        elsif @tweet_ids.index(tweet_id)
            return
        else
            @account_ids << account_id
            @tweet_ids << tweet_id
            @results << elems
            puts "#{elems[0][:created_at]} / #{elems[0][:followers_count]} / #{elems[0][:text]}" if (@line_count + 1) % 10000 == 0
        end
    end

    def set_elems(tweet_id, account_id_index, elems)
        if tweet_id > @tweet_ids[account_id_index]
            @results.slice!(account_id_index) # 代入すると時系列が入れ替わるため、古いツイートを削除してから末尾に挿入
            @results << elems
            @tweet_ids[account_id_index] = tweet_id
        else
        end
    end

    def out_xls(filename)
        book = Spreadsheet::Workbook.new
        sheet = book.create_worksheet
        hash = @hash_list
        hash.keys.each_with_index do |key, j|
            sheet[0, j] = "#{key}"
            hash[key].each_with_index do |value, i|
                sheet[i+1, j] = hash[key][i]
            end
        end
        puts "Write..."
        book.write "./#{filename}.xls"
        puts "./#{filename}.xls"
    end
end