# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    nickname              {'test'}
    email                 {Faker::Internet.email}
    password              {'a1' + Faker::Internet.password(min_length: 6)}
    password_confirmation {password}
    last_name             {'山田'}
    first_name            {'太郎'}
    last_name_kana        {'ヤマダ'}
    first_name_kana       {'タロウ'}
    birth_date            {'1990-01-01'} 
  end
end

# spec/factories/order_shipping_forms.rb
FactoryBot.define do
  factory :order_shipping_form do
    # ... 有効なフォーム入力値の定義
    token             { 'tok_abcdefghijklmnopqrstuvwxyz' }
    postal_code       { '123-4567' }
    shipping_from_id  { 2 }
    city              { '横浜市緑区' }
    address           { '青山1-1-1' }
    phone_number      { '09012345678' }
  end
end