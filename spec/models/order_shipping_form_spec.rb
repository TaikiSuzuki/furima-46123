require 'rails_helper'

RSpec.describe OrderShippingForm, type: :model do
  # 共通のテストデータを作成
  let(:user) { FactoryBot.create(:user) }
  let(:item) { FactoryBot.create(:item) }
  
  # 有効なパラメータ
  let(:valid_params) do
    FactoryBot.attributes_for(:order_shipping_form).merge(
      user_id: user.id,
      item_id: item.id,
    )
  end

  # 正常系テスト
  describe '正常系' do
    context 'すべての値が正しく入力されている場合' do
      it '保存できること' do
        form = OrderShippingForm.new(valid_params)
        expect(form).to be_valid
        expect { form.save }.to change(Order, :count).by(1).and change(ShippingAddress, :count).by(1)
      end

      # 建物名は空でも保存できること
      it '建物名は空でも保存できること' do
        form = OrderShippingForm.new(valid_params.merge(building: nil))
        expect(form).to be_valid
      end
    end
  end

  
  # 異常系テスト
  describe '異常系' do
    # 必須項目に関するテスト
    context '必須項目が空の場合' do
      it 'tokenが空では保存できないこと' do
        form = OrderShippingForm.new(valid_params.merge(token: nil))
        expect(form).to be_invalid
        expect(form.errors[:token]).to include("can't be blank")
      end

      it 'postal_codeが空では保存できないこと' do
        form = OrderShippingForm.new(valid_params.merge(postal_code: nil))
        expect(form).to be_invalid
        expect(form.errors[:postal_code]).to include("can't be blank")
      end

      it 'shipping_from_idが空では保存できないこと' do
        form = OrderShippingForm.new(valid_params.merge(shipping_from_id: nil))
        expect(form).to be_invalid
        expect(form.errors[:shipping_from_id]).to include("can't be blank")
      end
      
      it 'cityが空では保存できないこと' do
        form = OrderShippingForm.new(valid_params.merge(city: nil))
        expect(form).to be_invalid
        expect(form.errors[:city]).to include("can't be blank")
      end

      it 'addressが空では保存できないこと' do
        form = OrderShippingForm.new(valid_params.merge(address: nil))
        expect(form).to be_invalid
        expect(form.errors[:address]).to include("can't be blank")
      end

      it 'phone_numberが空では保存できないこと' do
        form = OrderShippingForm.new(valid_params.merge(phone_number: nil))
        expect(form).to be_invalid
        expect(form.errors[:phone_number]).to include("can't be blank")
      end
    end

    # 形式に関するテスト
    context '形式が不正な場合' do
      it 'postal_codeが3桁-4桁の形式でなければ保存できないこと' do
        form = OrderShippingForm.new(valid_params.merge(postal_code: '1234567'))
        expect(form).to be_invalid
        expect(form.errors[:postal_code]).to include("is invalid. Include hyphen(-)")
      end

      it 'shipping_from_idが1では保存できないこと' do
        form = OrderShippingForm.new(valid_params.merge(shipping_from_id: 1))
        expect(form).to be_invalid
        expect(form.errors[:shipping_from_id]).to include("must be other than 1")
      end

      it 'phone_numberが9桁以下では保存できないこと' do
        form = OrderShippingForm.new(valid_params.merge(phone_number: '090123456'))
        expect(form).to be_invalid
        # 期待するメッセージをモデルが返すメッセージに合わせる
        expect(form.errors[:phone_number]).to include("is invalid. Without hyphen(-)", "is the wrong length")
      end

      it 'phone_numberが12桁以上では保存できないこと' do
        form = OrderShippingForm.new(valid_params.merge(phone_number: '090123456789'))
        expect(form).to be_invalid
        # 期待するメッセージをモデルが返すメッセージに合わせる
        expect(form.errors[:phone_number]).to include("is invalid. Without hyphen(-)", "is the wrong length")
      end

      it 'phone_numberにハイフンが含まれている場合は保存できないこと' do
        form = OrderShippingForm.new(valid_params.merge(phone_number: '090-123-456'))
        expect(form).to be_invalid
        expect(form.errors[:phone_number]).to include("is invalid. Without hyphen(-)")
      end
    end

    # 外部キーに関するテスト
    context '外部キーに関するテスト' do
      it 'user_idが空では保存できないこと' do
        form = OrderShippingForm.new(valid_params.merge(user_id: nil))
        expect(form).to be_invalid
        expect(form.errors[:user_id]).to include("can't be blank")
      end

      it 'item_idが空では保存できないこと' do
        form = OrderShippingForm.new(valid_params.merge(item_id: nil))
        expect(form).to be_invalid
        expect(form.errors[:item_id]).to include("can't be blank")
      end
    end
  end
end
