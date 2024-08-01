class Api::V1::BooksController < ApplicationController
  # These will handle exceptions for all actions in this controller
  # rescue_from ActiveRecord::RecordNotFound, with: :not_found
  # rescue_from ActiveRecord::RecordNotDestroyed, with: :not_destroyed

  # Named constant
  MAX_PAGINATION_LIMIT = 100

  def index
    books = Book.limit(limit).offset(params[:offset])

    render json: BooksRepresenter.new(books).as_json
  end

  def create
    author = Author.create!(author_params)
    book = Book.new(book_params.merge(author_id: author.id))

    # let's say, whenever we create a book, we have to call some external api to do sth.
    # Waiting for the external api to respond will always take time. This is going to
    # affect our api performance and ultimately could cause requests to back up and start
    # to fail e.g. timeouts. Imagine we have a lot of requests to our server. Our server
    # would be in trouble. Instead, we want to return a response quickly to the api
    # caller so that it knows the request has been successfully processed. Then we can
    # perform the complex operation asynchronously.

    # This queues the active job and proceeds with code execution, no waiting
    UpdateSkuJob.perform_later(book_params[:title])

    # raise 'exit'

    if book.save
      render json: BookRepresenter.new(book).as_json, status: :created
    else
      render json: book.errors, status: :unprocessable_entity
    end
  end

  def destroy
    # The bang (!) after destroy returns true if the book is found and destroyed
    # Otherwise if it fails it will return an exception which we can handle
    # If it fails to get the book, raises a RecordNotFound exception
    # If it fails to destroy the book raises a RecordNotDestroyed exception
    # -> Adding rescue blocks to controller actions has some disadvantages - it bloats our controller action logic and we can't reuse them
    # -> A better way to handle these is to use 'rescue_from' at the top of the controller
    Book.find(params[:id]).destroy!

    head :no_content # returns 204 response in the head of the request, no request body

    # rescue ActiveRecord::RecordNotFound
    #   render json: { error: "Book not found!"}, status: :not_found

    # rescue ActiveRecord::RecordNotDestroyed
    #   render json: {}, status: :unprocessable_entity
  end

  # we can use the default rails params (params[:something]) OR the gem 'rails-param'
  # that gem allows us to typecheck and add messages for when params are wrong/missing
  private

  def limit
    [
      params.fetch(:limit, MAX_PAGINATION_LIMIT).to_i,
      MAX_PAGINATION_LIMIT
    ].min
  end

  def author_params
    params.require(:author).permit(:first_name, :last_name, :age)
  end

  def book_params
    params.require(:book).permit(:title)
  end
  

  # rescue_from methods
  #
  # def not_found
  #   render json: {}, status: :not_found
  # end

  # def not_destroyed
  #   render json: {}, status: :unprocessable_entity
  # end
end
