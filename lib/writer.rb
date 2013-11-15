class Writer

    public
    def initialize(keyword, requested_output_name = nil)
        @keyword = keyword
        @requested_output_name = requested_output_name
        @output_name = get_output_name
        @day = Time.now
        @wdays = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
    end
    attr_reader :output_name

    def get_output_name
        keyword_exchange = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/../config/twkeyword.yaml'))
        if @requested_output_name && @requested_output_name != keyword_exchange[@keyword]
            raise "twkeyword.yaml written \n#{keyword_exchange[@keyword]}\n"
        elsif keyword_exchange[@keyword]
            return keyword_exchange[@keyword]
        else
            raise "twkeyword.yaml has no keyword \'#{@keyword}\'"
        end
    end

    def make_dir
        FileUtils::mkdir_p("./tweet/#{@output_name}/#{@day.year}/#{@day.month}") unless FileTest.exist?("./tweet/#{@output_name}/#{@day.year}/#{@day.month}")
        FileUtils::mkdir_p("./tweet/id") unless FileTest.exist?("./tweet/id}")
        FileUtils::mkdir_p("./tweet/error") unless FileTest.exist?("./tweet/error}")
    end

    def get_since_id
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

    private
    def create_tweet_filename
        return "#{@output_name}/#{@day.year}/#{@day.month}/#{@day.year}-#{@day.month}-#{@day.day}-#{@wdays[@day.wday]}_#{@output_name}.ltsv"
    end

    def create_error_filename
        return "error/err_#{@day.year}-#{@day.month}-#{@day.day}-#{@wdays[@day.wday]}_#{@output_name}.txt"
    end

    def create_id_filename
        return "id/#{@output_name}.txt"
    end

end