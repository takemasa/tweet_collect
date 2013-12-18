require 'bundler/setup'
Bundler.require

class Authenticater

    def initialize(account_id = nil)
        @tw_access_key = check_twaccount
        @aws_access_key = check_awsaccount
        @tw_key = get_access_key(account_id)
        @aws_key = get_aws_access
    end
    attr_reader :tw_key
    attr_reader :aws_key
    attr_reader :tw_access_key
    attr_reader :aws_access_key

    def check_twaccount
        twaccount = File.expand_path(File.dirname(__FILE__) + '/../config/twaccount.yaml')
        File.open(twaccount,'a+') unless FileTest.exist?(twaccount)
        return YAML.load_file(twaccount)
    end

    def check_awsaccount
        awsaccount = File.expand_path(File.dirname(__FILE__) + '/../config/aws.yaml')
        File.open(awsaccount,'a+') unless FileTest.exist?(awsaccount)
        return YAML.load_file(awsaccount)
    end

    def get_access_key(account_id)
        if @tw_access_key && @tw_access_key["consumer_key_#{account_id}"]
            return ({
                :consumer_key => @tw_access_key["consumer_key_#{account_id}"],
                :consumer_secret => @tw_access_key["consumer_secret_#{account_id}"],
                :oauth_token => @tw_access_key["oauth_token_#{account_id}"],
                :oauth_token_secret => @tw_access_key["oauth_token_secret_#{account_id}"]
                })
        else
            nil
        end
    end
    private :get_access_key

    def get_twitter_client
        raise 'account not exist' unless @tw_key
        tw_client = Twitter::Client.new(@tw_key)
    end

    def get_aws_access
        if @aws_access_key
            return ({
                    :access_key_id => @aws_access_key["aws_access_key"],
                    :secret_access_key => @aws_access_key["aws_secret_access_key"],
                    :s3_endpoint => @aws_access_key["region"]
                    })
        else
            nil
        end
    end

    def get_aws_client
        @aws_key ? aws_client = AWS::S3.new(@aws_key) : raise{'no credentials'}
    end
end