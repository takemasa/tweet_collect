require 'bundler/setup'
Bundler.require

class Authenticater

    def initialize(account_id = nil)
        @tw_access_key = check_twaccount
        @tw_key = get_access_key(account_id)
    end
    attr_reader :tw_key
    attr_reader :tw_access_key

    def check_twaccount
        twaccount = File.expand_path(File.dirname(__FILE__) + '/../config/twaccount.yaml')
        File.open(twaccount,'a+') unless FileTest.exist?(twaccount)
        return YAML.load_file(twaccount)
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
    end
end