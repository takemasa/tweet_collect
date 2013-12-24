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
        filepass = []
        (Date.parse(from)..Date.parse(to)).each{ |i|
            date = i.to_s
            year, month, day = date.split('-')
            self.get_keyword.each do |keyword| filepass << "dsb-twitter/#{keyword}/#{year}/#{month}/#{date}" end
        }
        filepass
    end
end