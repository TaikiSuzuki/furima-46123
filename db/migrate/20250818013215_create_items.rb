class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|

      ## itemsテーブル更新
      t.string :name, null: false
      t.text :description, null: false
      t.integer :price, null: false
      t.integer :category_id, null: false
      t.integer :condition_id, null: false
      t.integer :shipping_fee_payer_id, null: false
      t.integer :shipping_from_id, null: false
      t.integer :days_to_ship_id, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
