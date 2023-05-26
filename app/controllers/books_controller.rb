class BooksController < ApplicationController
  def index
    render json: Book.all
  end

  def create
    book = Book.new(book_params)

    if book.save
      render json: book, status: :created
    else
      render json: book.errors, status: :unprocessable_entity
    end
  end

  def destroy
    # The bang (!) after destroy returns true if the book is found and destroyed
    # Otherwise if it fails it will return an exception which we can handle
    Book.find(params[:id]).destroy!

    head :no_content # returns 204 response in the head of the request, no request body
  end

  # we can use the default rails params (params[:something]) OR the gem 'rails-param'
  # that gem allows us to typecheck and add messages for when params are wrong/missing
  private

  def book_params
    params.require(:book).permit(:title, :author)
  end
end
