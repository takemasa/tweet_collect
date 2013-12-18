require 'bundler/setup'
Bundler.require

class Authenticater

    def initialize(account_id = nil)
        @tw_key = get_access_key(account_id)
    end
    attr_reader :tw_key

    def get_access_key(account_id)
        access_key = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/../config/twaccount.yaml'))
        if access_key["consumer_key_#{account_id}"]
            return ({
                :consumer_key => access_key["consumer_key_#{account_id}"],
                :consumer_secret => access_key["consumer_secret_#{account_id}"],
                :oauth_token => access_key["oauth_token_#{account_id}"],
                :oauth_token_secret => access_key["oauth_token_secret_#{account_id}"]
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