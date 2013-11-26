require_relative '../lib/authenticater.rb'
require_relative '../lib/register.rb'
require 'bundler/setup'
Bundler.require

register = Register.new

ary_username = []
consumer_key = register.ask_consumer_key
consumer_secret = register.ask_consumer_secret
oauth_token = register.ask_oauth_token
oauth_token_secret = register.ask_oauth_token_secret

# 初回起動時はyamlファイルが存在しない可能性があるため'a+'モードでopenする
File.open("config/twaccount.yaml",'a+')
tw_account = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/../config/twaccount.yaml'))
new_account_id = 1
while tw_account["username_#{new_account_id}"]
    ary_username << tw_account["username_#{new_account_id}"]
    new_account_id += 1
end

twkey = {
    :consumer_key => consumer_key,
    :consumer_secret => consumer_secret,
    :oauth_token => oauth_token,
    :oauth_token_secret => oauth_token_secret
}
begin
    username = Twitter::Client.new(twkey).user.screen_name
rescue
    raise 'Authentication failed, Retry input.'
end

unless ary_username.include?(username)
    File.open("config/twaccount.yaml",'a'){|file|
        file.puts "\nconsumer_key_#{new_account_id}: #{consumer_key}\nconsumer_secret_#{new_account_id}: #{consumer_secret}\noauth_token_#{new_account_id}: #{oauth_token}\noauth_token_secret_#{new_account_id}: #{oauth_token_secret}\nusername_#{new_account_id}: #{username}\n"
    }
    puts "your account_id is #{new_account_id}"
else
    puts "#{username} has already been recorded in twaccount.yaml."
end