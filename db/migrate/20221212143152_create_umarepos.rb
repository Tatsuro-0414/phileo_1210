class CreateUmarepos < ActiveRecord::Migration[6.0]
  def change
    create_table :umarepos do |t|
      t.string :title , null: false
      t.string :comment , null: false
      t.text        :image



      t.timestamps
    end
  end
end
