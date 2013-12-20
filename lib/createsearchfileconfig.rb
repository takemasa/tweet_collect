class CreateSearchFileConfig


    def initialize
        @search_config = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "/../config/search_config.yaml"))
        @tw_keyword = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "/../config/twkeyword.yaml"))
    end
    attr_reader :search_config
    attr_reader :tw_keyword

    def get_keyword
         search_keyword= []
        twk_config = @search_config['keyword']
        twk_config.each{|twkconf| search_keyword << @tw_keyword[twkconf]}
        search_keyword
    end

    def create_filepass
        from = @search_config['from']
        to = @search_config['to']
        fyear, fmonth, fday = from.split('/')
        tyear, tmonth, tday = to.split('/')
        yearspan = []
        for i in fyear..tyear; yearspan << i; end
        monthspan = []
        for i in fmonth..tmonth; monthspan << i; end
        dayspan = []
        for i in fday..tday; dayspan << i; end
        keyword = self.get_keyword
        filepass = []
        keyword.each do |key|
            yearspan.each do |year|
                monthspan.each do |month|
                    dayspan.each do |day|
                        filepass << "dsb-twitter/#{key}/#{year}/#{month}/#{year}-#{month}-#{day}"
                    end
                end
            end
        end
        filepass
    end

end