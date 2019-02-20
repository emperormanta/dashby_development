class GraphqlApi
  class << self
    attr_accessor :token_api
  end
  def self.customer(query)
    HTTParty.post("#{CONFIG["customer_api"]}?auth_token=#{self.token_api}",
      :body => {
        query: query
      }.to_json,
      :headers => {'Content-Type' => 'application/json'}
    )
  end
  def self.xcost(query)
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Bearer #{self.token_api}"
    }
    HTTParty.post("#{CONFIG["xcost_api"]}",
      :body => {
        query: query
      }.to_json,
      :headers => headers
    )
  end
  # def self.procurement(query)
  #   HTTParty.post("#{CONFIG["procurement_api"]}?auth_token=#{self.token_api}",
  #     :body => {
  #       query: query
  #     }.to_json,
  #     :headers => {'Content-Type' => 'application/json'}
  #   )
  # end
  # def self.warehouse(query)
  #   HTTParty.post("#{CONFIG['warehouse_api']}?auth_token=#{self.token_api}",
  #     :body => {
  #       query: query
  #     }.to_json,
  #     :headers => {'Content-Type' => 'application/json'}
  #   )
  # end
end