require 'bundler/setup'
Bundler.require

class Authenticater

    def initialize(account_id)
        @tw_access_key = get_access_key(account_id)
    end
    attr_reader :tw_access_key

    def get_access_key(account_id)
        tw_access_key = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/../config/twaccount.yaml'))
        if tw_access_key["consumer_key_#{account_id}"]
            return ({
                :consumer_key => tw_access_key["consumer_key_#{account_id}"],
                :consumer_secret => tw_access_key["consumer_secret_#{account_id}"],
                :oauth_token => tw_access_key["oauth_token_#{account_id}"],
                :oauth_token_secret => tw_access_key["oauth_token_secret_#{account_id}"]
                })
        else
            raise 'account_id not exist'
        end
    end
    private :get_access_key

    def get_client
            client = Twitter::Client.new(@tw_access_key)
    end
end