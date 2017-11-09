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
        status = res.code
        JSON.parse(res.body)
    end

    def transactions(slug_bank_account, iban)
        res = RestClient.get(url + "/transaction?slug=#{slug_bank_account}&iban=#{iban}",
                             {"Authorization" => "#{slug}:#{secret}"}
        )

        puts res
        status = res.code
        JSON.parse(res.body)
    end

    def iban
        organizations["organization"]["bank_accounts"][0]["iban"]
    end

    def slug_bank_account
        organizations["organization"]["bank_accounts"][0]["slug"]
    end

end

client = QontoClient.new('qonto-test-9312', 'b5e1cdfc34b0')

slug = client.slug_bank_account
iban = client.iban

puts client.transactions(slug, iban)

meta = client.transactions(slug, iban)