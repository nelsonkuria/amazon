require 'rails_helper'

RSpec.describe Api::V1::BooksController, type: :controller do
  # We could create 101 books and try to assert that only 100 books are returned
  # This would be very inneficient
  # Instead, we assert that the Book model receives a limit query with the
  # correct params because we can trust the limit method to do its thing, since it is
  # built in to rails
  # Let's default to a limit of 100

  it 'has a max limit of 100' do
    # This expect(Book).to receive(:limit).with(100) mocks the object. If we don't add 
    # `and_call_original`, our test will fail because we are not specifying a return value.
    # It basically tells the model to continue on its execution path
    expect(Book).to receive(:limit).with(100).and_call_original

    # For controller specs, we don't call the url, we call the controller action
    get :index, params: { limit: 999 }
  end
end
