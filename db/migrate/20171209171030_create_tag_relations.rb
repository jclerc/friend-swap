class CreateTagRelations < ActiveRecord::Migration[5.1]
  def change
    create_table :tag_relations do |t|
      t.references :exchange, foreign_key: true
      t.references :tag, foreign_key: true
      t.references :friend, foreign_key: true

      t.timestamps
    end
  end
end
