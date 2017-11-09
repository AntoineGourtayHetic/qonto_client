require 'json'
require 'rest-client'


class QontoClient

    attr_reader :slug, :secret, :url

    #COnstructeur
    def initialize(slug, secret)
        @slug = slug
        @secret = secret
        @url = 'https://thirdparty.qonto.eu/v1'
    end

    #Méthode
    def organizations
        res = RestClient.get(@url + "/organizations/#{slug}",
                       {"Authorization" => "#{slug}:#{secret}"}
        )
        return "Erreur : #{res.status}" if res.code.to_i != 200
        JSON.parse(res.body)
    end

    def iban
        organizations["bank_accounts"][0]["iban"]
    end

    def slug_bank_account
        organizations["bank_accounts"][0]["slug"]
    end

end

client = QontoClient.new('qonto-test-9312', 'b5e1cdfc34b0')
orga = client.organizations
puts "Votre balance est de #{orga["organization"]["bank_accounts"][0]["balance"]}"