class AddIndexShortUrlUser < ActiveRecord::Migration
  def change
    add_index :shortened_urls, :user_id
  end
end
