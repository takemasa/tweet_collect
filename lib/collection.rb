# coding: utf-8
require 'bundler/setup'
Bundler.require

class Collector

    def initialize(keyword = nil, account_num = nil, since_id = nil)
        @keyword = keyword
        @account_num = account_num
    end

    def search_tw
        return "success"
    end

    def file(keyword)
        file = @keyword.search_tw
        return "status #{file}"
    end

end
