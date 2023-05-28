# this migration was generated using the command
# bin/rails g migration add_author_to_books author:references
class AddAuthorToBooks < ActiveRecord::Migration[7.0]
  def change
    add_reference :books, :author
  end
end
