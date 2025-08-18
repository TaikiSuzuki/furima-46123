FactoryBot.define do
  factory :item do
    name              { 'テスト商品' }
    description       { 'これはテスト用の商品説明です。' }
    price             { 500 }
    category_id       { 2 } # 1は「---」に該当するため、それ以外のIDを設定
    condition_id      { 2 }
    shipping_fee_payer_id { 2 }
    shipping_from_id  { 2 }
    days_to_ship_id   { 2 }
    
    # has_one_attached :image のための設定
    after(:build) do |item|
      item.image.attach(io: File.open(Rails.root.join('public/images/test_image.png')), filename: 'test_image.png')
    end

    association :user
  end
end