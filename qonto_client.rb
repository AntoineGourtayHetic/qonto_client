require 'rest-client'

class QontoClient

    attr_reader :slug, :secret, :url

    def initialize(slug, secret)
        @slug = slug
        @secret = secret
        @url = 'https://thirdparty.qonto.eu/v1'
    end

    def organizations
        res = RestClient.get(@url + "/organizations/#{slug}",
                       {"Authorization" => "#{slug}:#{secret}"}
        )
        
        puts res.code
        puts res.body
    end

end


client = QontoClient.new('qonto-test-9312', 'b5e1cdfc34b0')
client.organizations
