 require 'rails_helper'

RSpec.describe UpdateSkuJob, type: :job do
  let(:book_title) { 'eloquent ruby' }

  before do
    # We stub out Net::HTTP because we don't actually want to fire the request
    allow(Net::HTTP).to receive(:start).and_return(true)
  end

  it 'calls SKU service with correct params' do
    expect_any_instance_of(Net::HTTP::Post).to receive(:body=).with(
      {sku: 'q2357', title: book_title}.to_json
    )

    described_class.perform_now(book_title)
  end
end
