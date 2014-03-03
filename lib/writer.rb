class Writer

    public
    def initialize(keyword)
        @keyword = keyword
        @output_name = get_output_name
        @day = Time.now
        @wdays = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
    end
    attr_reader :output_name

    def get_output_name
        keyword_exchange = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/../config/twkeyword.yaml'))
        keyword_exchange[@keyword] ? keyword_exchange[@keyword] : raise("twkeyword.yaml has no keyword \'#{@keyword}\'")
    end

    def make_dir
        FileUtils::mkdir_p("./tweet/data/#{@output_name}/#{@day.year}/#{@day.strftime("%m")}") unless FileTest.exist?("./tweet/data/#{@output_name}/#{@day.year}/#{@day.strftime("%m")}")
        FileUtils::mkdir_p("./tweet/id") unless FileTest.exist?("./tweet/id}")
        FileUtils::mkdir_p("./tweet/error") unless FileTest.exist?("./tweet/error}")
        FileUtils::mkdir_p("./tweet/log") unless FileTest.exist?("./tweet/log}")
    end

    def output_tweet(tweet)
        tweet_filename = create_tweet_filename
        File.open("./tweet/data/#{tweet_filename}",'a+'){|file|
            file.puts tweet
        }
    end

    def output_error(error_ary)
        error_filename = create_error_filename
        File.open("./tweet/#{error_filename}",'a+'){|tweet|
            tweet.puts error_ary
        }
    end

    def output_id(id_ary)
        id_filename = create_id_filename
        File.open("./tweet/#{id_filename}",'a+'){|tweet|
            tweet.puts id_ary
        }
    end

    def output_log(log_ary)
        log_filename = create_log_filename
        log_ary ? sum_ary = log_ary.compact.inject{|sum,n| sum+n} : sum_ary = 0
        File.open("./tweet/#{log_filename}",'a+'){|tweet|
            tweet.puts "execute_time:#{@day}\ttimes:#{log_ary.compact.count}\ttweets:#{sum_ary}"
        }
    end

    def create_id_filename
        "id/#{@output_name}.txt"
    end

    private
    def create_tweet_filename
        "#{@output_name}/#{@day.year}/#{@day.strftime("%m")}/#{@day.strftime("%Y-%m-%d")}-#{@wdays[@day.wday]}_#{@output_name}.ltsv"
    end

    def create_error_filename
        "error/err_#{@day.strftime("%Y-%m-%d")}-#{@wdays[@day.wday]}_#{@output_name}.ltsv"
    end

    def create_log_filename
        "log/#{@day.strftime("%Y-%m-%d")}-#{@wdays[@day.wday]}_#{@output_name}.ltsv"
    end


end