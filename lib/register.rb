class Register

    def ask_consumer_key
        print "your consumer_key :"
        consumer_key = STDIN.gets.chomp
    end

    def ask_consumer_secret
        print "your consumer_secret :"
        consumer_secret = STDIN.gets.chomp
    end

    def ask_oauth_token
        print "your oauth_token :"
        oauth_token = STDIN.gets.chomp
    end

    def ask_oauth_token_secret
        print "your oauth_token_secret :"
        oauth_token_secret = STDIN.gets.chomp
    end
end