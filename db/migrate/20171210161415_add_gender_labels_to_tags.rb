class AddGenderLabelsToTags < ActiveRecord::Migration[5.1]
  def change
    rename_column :tags, :label, :label_male
    add_column :tags, :label_female, :string
  end
end
