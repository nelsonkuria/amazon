require 'net/http'

# ran `bin/rails generate job update_sku` to create this job
class UpdateSkuJob < ApplicationJob
  queue_as :default

  def perform(book_title)
    uri = URI('http://localhost:8080/update_sku')
    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    req.body = {sku: 'q2357', title: book_title}.to_json
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
  end
end
