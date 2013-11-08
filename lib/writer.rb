class Writer

    def initialize(keyword, dir_name = nil)
    	dir = YAML.load_file('./config/twkeyword.yaml')
        	@keyword = keyword
        	@dir_name = dir[keyword]
    end

    def get_dir_name
    	if @dir_name
    		return @dir_name
    	else
    		p 'dir_name not exist in ./config/twkeyword.yaml'
    	end
    end

    def make_dir
    	FileUtils::mkdir_p("./tweet/test") unless FileTest.exist?("./tweet/test")
    end

    def last_id
        return 9999
    end

end