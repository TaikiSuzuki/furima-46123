require 'rails_helper'

RSpec.describe "Orders", type: :request do
  # 共通のテストデータを作成
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:item) { create(:item, user: other_user) }
  let(:sold_item) { create(:item, user: user) }

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
        allow(Payjp::Charge).to receive(:create).and_return(double('charge', id: 'dummy_charge_id'))
      end
      # attributes_forで生成したパラメータにuser_idとitem_idをマージ
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
      before do
        sign_in user
      end

      let(:invalid_postal_code_params) { attributes_for(:order_shipping_form, postal_code: '1234567').merge(user_id: user.id, item_id: item.id) }
      let(:invalid_token_params) { attributes_for(:order_shipping_form, token: nil).merge(user_id: user.id, item_id: item.id) }
      
      it '無効な郵便番号ではデータベースに保存されない' do
        expect {
          post item_orders_path(item), params: { order_shipping_form: invalid_postal_code_params }
        }.to_not change(Order, :count)
      end

      it 'トークンが空ではデータベースに保存されない' do
        expect {
          post item_orders_path(item), params: { order_shipping_form: invalid_token_params }
        }.to_not change(Order, :count)
      end

      it '無効な郵便番号では購入ページに戻る' do
        post item_orders_path(item), params: { order_shipping_form: invalid_postal_code_params }
        expect(response).to have_http_status(422)
      end
      
      it '無効な郵便番号ではエラーメッセージが表示される' do
        post item_orders_path(item), params: { order_shipping_form: invalid_postal_code_params }
        expect(response.body).to include('Postal code is invalid')
      end

      it 'トークンが空では購入ページに戻る' do
        post item_orders_path(item), params: { order_shipping_form: invalid_token_params }
        expect(response).to have_http_status(422)
      end

      it 'トークンが空ではエラーメッセージが表示される' do
        post item_orders_path(item), params: { order_shipping_form: invalid_token_params }
        expect(response.body).to include("Token can't be blank")
      end
    end
  end

  # --- GETの異常系テスト ---
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
end