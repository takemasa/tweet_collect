class Cleaner

    def initialize(keyword, requested_dir_name = nil)
    	@tweets_ary = tweets_ary
        @error_ary = error_ary
        @id_ary = id_ary
    end
    attr_accessor :tweets_ary
    attr_accessor :error_ary
    attr_accessor :id_ary
end