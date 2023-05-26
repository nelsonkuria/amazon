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

  # we can use the default rails params (params[:something]) OR the gem 'rails-param'
  # that gem allows us to typecheck and add messages for when params are wrong/missing
  private

  def book_params
    params.require(:book).permit(:title, :author)
  end
end
