class AddDetailsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :subject, :string
    add_column :users, :body, :string
    add_column :users, :attachments, :string
  end
end
