class OrderShippingForm
  include ActiveModel::Model
  attr_accessor :user_id, :item_id, :token,
                :postal_code, :shipping_from_id, :city, :address, :building, :phone_number

  # バリデーション
  with_options presence: true do
    validates :user_id
    validates :item_id
    # validates :token テストのためいったんコメントアウト
    validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/ }
    validates :shipping_from_id, numericality: { other_than: 1 }
    validates :city
    validates :address
    validates :phone_number, format: { with: /\A\d{10,11}\z/ }
  end

def save
  ActiveRecord::Base.transaction do
    order = Order.create!(user_id: user_id, item_id: item_id)
    ShippingAddress.create!(
      postal_code: postal_code,
      shipping_from_id: shipping_from_id,
      city: city,
      address: address,
      building: building,
      phone_number: phone_number,
      order_id: order.id
    )
  end
  true 
rescue ActiveRecord::RecordInvalid
  false
end

end