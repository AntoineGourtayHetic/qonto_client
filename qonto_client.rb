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

    def iban
        organizations["organization"]["bank_accounts"][0]["iban"]
    end

    def slug_bank_account
        organizations["organization"]["bank_accounts"][0]["slug"]
    end

    #Méthode
    def organizations
        res = RestClient.get(@url + "/organizations/#{slug}",
                       {"Authorization" => "#{slug}:#{secret}"}
        )
        status = res.code
        JSON.parse(res.body)
    end

    def call_transaction(next_page = 1)
        res = RestClient.get(url + "/transactions?slug=#{slug_bank_account}&iban=#{iban}&params=#{next_page}",
                             {"Authorization" => "#{slug}:#{secret}"}
        )

        status = res.code
        JSON.parse(res.body)
    end

    def all_transactions(full_transactions = [], next_page = 1)

        full_transactions << call_transaction["transactions"]

        if (full_transactions["meta"]["total_count"]).to_i == 100
            full_transactions << all_transactions(full_transactions, next_page: transacs["meta"]["next_page"])
        end

      all_transactions

    end


end


client = QontoClient.new('qonto-test-9312', 'b5e1cdfc34b0')

transactions = client.all_transactions["transactions"]
puts transactions.count