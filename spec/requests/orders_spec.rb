# spec/requests/orders_spec.rb
require 'rails_helper'

RSpec.describe "Orders", type: :request do
  # 共通のテストデータを作成
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:item) { create(:item, user: other_user) }
  let(:sold_item) { create(:item, user: other_user) }

  before do
    # 販売済み商品の購入レコードを事前に作成
    create(:order, item: sold_item, user: user)
  end

  # --- 正常系テスト ---
  describe "GET /items/:item_id/orders" do
    context 'ログイン済みのユーザーの場合' do
      before do
        sign_in user
      end
      it '自身が出品していない販売中の商品の購入ページに遷移できる' do
        get item_orders_path(item)
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "POST /items/:item_id/orders" do
    context '有効なパラメータの場合' do
      before do
        sign_in user
      end
      let(:valid_params) { attributes_for(:order_shipping_form) }
      
      it 'データベースにOrderとShippingAddressのレコードが保存される' do
        expect {
          post item_orders_path(item), params: { order_shipping_form: valid_params }
        }.to change(Order, :count).by(1).and change(ShippingAddress, :count).by(1)
      end

      it 'トップページにリダイレクトされる' do
        post item_orders_path(item), params: { order_shipping_form: valid_params }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  # --- 異常系テスト ---
  describe "GET /items/:item_id/orders" do
    context 'ログイン済みのユーザーの場合' do
      before do
        sign_in user
      end

      it '自身が出品した商品の購入ページに遷移しようとするとトップページにリダイレクトされる' do
        my_item = create(:item, user: user)
        get item_orders_path(my_item)
        expect(response).to redirect_to(root_path)
      end

      it '自身が出品していない売却済み商品の購入ページに遷移しようとするとトップページにリダイレクトされる' do
        get item_orders_path(sold_item)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'ログインしていないユーザーの場合' do
      it '商品購入ページに遷移しようとするとログインページにリダイレクトされる' do
        get item_orders_path(item)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /items/:item_id/orders" do
    before do
      sign_in user
    end
    let(:invalid_params) { attributes_for(:order_shipping_form, postal_code: '1234567') }

    context '無効なパラメータの場合' do
      it 'データベースに保存されない' do
        expect {
          post item_orders_path(item), params: { order_shipping_form: invalid_params }
        }.to_not change(Order, :count)
      end

      it '購入ページに戻る' do
        post item_orders_path(item), params: { order_shipping_form: invalid_params }
        expect(response).to have_http_status(200)
      end
      
      it 'エラーメッセージが表示される' do
        post item_orders_path(item), params: { order_shipping_form: invalid_params }
        expect(response.body).to include('Postal code is invalid')
        # その他のバリデーションエラーメッセージも必要に応じて追加
      end
    end
  end
end