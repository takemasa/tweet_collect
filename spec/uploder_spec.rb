require 'uploder'

describe Uploder do

    after(:all) do
        system 'rm -f ./tweet/data/test/*/*/*'
    end

    wdays = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
    old_filename = "./tweet/data/test/#{Time.now.year}/#{Time.now.month}/#{Time.now.year}-#{Time.now.month}-#{Time.now.day-1}-#{wdays[Time.now.wday]}_test.ltsv.gz"
    new_filename = "./tweet/data/test/#{Time.now.year}/#{Time.now.month}/#{Time.now.year}-#{Time.now.month}-#{Time.now.day}-#{wdays[Time.now.wday]}_test.ltsv.gz"

    File.open("#{old_filename}",'a+')
    File.open("#{new_filename}",'a+')

end