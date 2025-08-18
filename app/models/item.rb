require 'active_hash'

class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :Category
  belongs_to :Condition
  belongs_to :DaysToShip
  belongs_to :ShippingFeePayer
  belongs_to :ShippingFrom

  belongs_to :user
  has_one_attached :image

with_options presence: true, numericality: { other_than: 1 } do
    validates :category_id
    validates :condition_id
    validates :shipping_fee_payer_id
    validates :shipping_from_id
    validates :days_to_ship_id
  end

  with_options presence: true do
    validates :image
    validates :name
    validates :description
    validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 300, less_than_or_equal_to: 9999999 }
  end
end
