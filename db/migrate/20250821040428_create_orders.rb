class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|

      # `users`テーブルと`items`テーブルへの参照を追加
      t.references :user, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
