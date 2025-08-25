require 'rails_helper'

RSpec.describe "Orders", type: :request do
  # 共通のテストデータを作成
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:item) { create(:item, user: other_user) }
  let(:sold_item) { create(:item, user: user) }

  before do
    build(:order, item: sold_item, user: user)
  end

  # --- GETリクエストのテスト ---
  describe "GET /items/:item_id/orders" do
    context 'ログイン済みのユーザーの場合' do
      before { sign_in user }

      it '自身が出品していない販売中の商品の購入ページに遷移できる' do
        get item_orders_path(item)
        expect(response).to have_http_status(200)
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

  # --- POSTリクエストのテスト ---
  describe "POST /items/:item_id/orders" do
    before { sign_in user }

    context '有効なパラメータの場合' do
      before do
        allow(Payjp::Charge).to receive(:create).and_return(double('charge', id: 'dummy_charge_id'))
      end
      let(:valid_params) { attributes_for(:order_shipping_form).merge(user_id: user.id, item_id: item.id) }
      
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

    context '無効なパラメータの場合' do
      it '無効な郵便番号ではデータベースに保存されない' do
        invalid_params = attributes_for(:order_shipping_form, postal_code: '1234567').merge(user_id: user.id, item_id: item.id)
        expect {
          post item_orders_path(item), params: { order_shipping_form: invalid_params }
        }.to_not change(Order, :count)
      end

      it '無効な郵便番号では購入ページに戻り、エラーメッセージが表示される' do
        invalid_params = attributes_for(:order_shipping_form, postal_code: '1234567').merge(user_id: user.id, item_id: item.id)
        post item_orders_path(item), params: { order_shipping_form: invalid_params }
        expect(response).to have_http_status(422)
        expect(response.body).to include('Postal code is invalid')
      end

      it 'トークンが空ではデータベースに保存されない' do
        invalid_params = attributes_for(:order_shipping_form, token: nil).merge(user_id: user.id, item_id: item.id)
        expect {
          post item_orders_path(item), params: { order_shipping_form: invalid_params }
        }.to_not change(Order, :count)
      end

      it 'トークンが空では購入ページに戻り、エラーメッセージが表示される' do
        invalid_params = attributes_for(:order_shipping_form, token: nil).merge(user_id: user.id, item_id: item.id)
        post item_orders_path(item), params: { order_shipping_form: invalid_params }
        expect(response).to have_http_status(422)
        expect(response.body).to include("Token can't be blank")
      end
    end
  end
end
