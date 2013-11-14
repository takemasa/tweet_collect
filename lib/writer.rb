class Writer

    def initialize(keyword, requested_output_name = nil)
            @keyword = keyword
            @requested_output_name = requested_output_name
            @output_name = get_output_name
    end
    attr_reader :output_name

    def get_output_name
        dir = YAML.load_file('/Users/takemasa/Desktop/git_repository/tweet_collect/config/twkeyword.yaml')
        if @requested_output_name && @requested_output_name != dir[@keyword]
            raise 'yaml check'
        elsif dir[@keyword]
            return dir[@keyword]
        else
            raise 'yaml check'
        end
    end

    def create_tweet_filename
        day = Time.now
        wdays = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
        return "#{@output_name}/#{day.year}/#{day.month}/#{day.year}-#{day.month}-#{day.day}-#{wdays[day.wday]}_#{@output_name}.ltsv"
    end
    private :create_tweet_filename

    def create_error_filename
        day = Time.now
        wdays = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
    	return "error/err_#{day.year}-#{day.month}-#{day.day}-#{wdays[day.wday]}_#{@output_name}.txt"
    end
    private :create_error_filename

    def create_id_filename
    	return "id/#{@output_name}.txt"
    end
    private :create_id_filename

    def make_dir
        day = Time.now
        FileUtils::mkdir_p("./tweet/#{@output_name}/#{day.year}/#{day.month}") unless FileTest.exist?("./tweet/#{@output_name}/#{day.year}/#{day.month}")
        FileUtils::mkdir_p("./tweet/id") unless FileTest.exist?("./tweet/id}")
        FileUtils::mkdir_p("./tweet/error") unless FileTest.exist?("./tweet/error}")
    end

    def get_last_id
    	id_filename = create_id_filename
        File.open("./tweet/#{id_filename}",'a+') {|f|
        		@since_id = f.readlines[-1].to_i
        }
        File.open("./tweet/#{id_filename}",'w')
        return @since_id
    end

    def output_tweet
        tweet_filename = create_tweet_filename
        File.open("./tweet/#{tweet_filename}",'a+'){|tweet|
            tweet.puts @tweets_ary
        }
    end

    def output_error
        error_filename = create_error_filename
        File.open("./tweet/#{error_filename}",'a+'){|tweet|
            tweet.puts @error_ary
        }
    end

    def output_id
        id_filename = create_id_filename
        File.open("./tweet/#{id_filename}",'a+'){|tweet|
            tweet.puts @id_ary
        }
    end
end