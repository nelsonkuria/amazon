# this migration was created using the command
# bin/rails g migration remove_author_from_books author:string
class RemoveAuthorFromBooks < ActiveRecord::Migration[7.0]
  def change
    remove_column :books, :author, :string
  end
end
