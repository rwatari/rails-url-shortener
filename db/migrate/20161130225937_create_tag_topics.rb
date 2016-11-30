class CreateTagTopics < ActiveRecord::Migration
  def change
    create_table :tag_topics do |t|
      t.string :name ,null: false, unique: true
      t.timestamps
    end
  end
end
