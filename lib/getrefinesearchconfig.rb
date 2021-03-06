class GetRefineSearchConfig


    def initialize
        @search_config = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "/../config/search_config.yaml"))
        @tw_keyword = YAML.load_file(File.expand_path(File.dirname(__FILE__) + "/../config/twkeyword.yaml"))
    end
    attr_reader :search_config
    attr_reader :tw_keyword

    def get_keyword
         keyword= []
        twk_config = @search_config['keyword']
        twk_config.each{|twkconf| keyword << @tw_keyword[twkconf]}
        keyword
    end

    def create_filepath
        from = @search_config['from']
        to = @search_config['to']
        filepath = []
        (Date.parse(from)..Date.parse(to)).each{ |i|
            date = i.to_s
            year, month, day = date.split('-')
            self.get_keyword.each do |keyword| filepath << "#{keyword}/#{year}/#{month}/#{date}" end
        }
        filepath
    end
end