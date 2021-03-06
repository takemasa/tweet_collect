# ランダムに5つのアカウントと相互フォロー関係になる
require_relative '../lib/authenticater.rb'
require 'bundler/setup'
Bundler.require
tw_username = YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/../config/twaccount.yaml')) # idが記述されている
new_account_id = ARGV[0] # 新規に作成したアカウントのid
all_account_ids = 1 # 保持している総アカウント数が入る
ary_username = []
ary_account_id = ["1"] # account_id = 1のアカウントとは常にフォロー関係になる

# yamlファイル内にいくつのアカウントがあるかを調べる
while tw_username["username_#{all_account_ids}"]
    all_account_ids += 1
end
all_account_ids -= 2 # 最後の加算分と最新のアカウント分はフォロー対象から除く
ary_account_id += (2..all_account_ids).to_a.sort_by{rand}[0..3]
ary_account_id.each{|user_id| ary_username << tw_username["username_#{user_id}"]}
# ARGVのアカウントが配列内のアカウントをフォロー
Authenticater.new(new_account_id).get_twitter_client.follow(ary_username)
new_user = tw_username["username_#{new_account_id}"]
puts "#{new_user} follow #{ary_username}\n"
# 配列内のアカウントがARGVで指定したアカウントをフォロー
ary_account_id.each{|old_account_id|
    Authenticater.new(old_account_id).get_twitter_client.follow(tw_username["username_#{new_account_id}"])
    old_user = tw_username["username_#{old_account_id}"]
    puts "#{old_user} follow #{new_user}"
    }
