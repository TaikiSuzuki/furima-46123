# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    before do
      @user = FactoryBot.build(:user)
    end
    
    # 正常系のテスト
    context '正常系' do
      it 'すべての項目が正しく入力されていれば有効な状態であること' do
        expect(@user).to be_valid
      end
    end
    
    # 異常系のテスト
    context '異常系' do
      # 各必須項目が空のときに登録できないこと
      it 'nicknameが空では登録できないこと' do
        @user.nickname = nil
        expect(@user).to_not be_valid
      end
      
      it 'emailが空では登録できないこと' do
        @user.email = nil
        expect(@user).to_not be_valid
      end
      
      it 'passwordが空では登録できないこと' do
        @user.password = nil
        expect(@user).to_not be_valid
      end

      it 'password_confirmationがpasswordと一致しない場合は登録できないこと' do
        @user.password = '123456'
        @user.password_confirmation = '1234567'
        expect(@user).to_not be_valid
      end

      # 重複したemailでは登録できないこと
      it '重複したemailでは登録できないこと' do
        FactoryBot.create(:user, email: @user.email)
        @user.valid?
        expect(@user.errors.full_messages).to include("Email has already been taken")
      end

      # emailに@を含まない場合は登録できないこと
      it 'emailに@を含まない場合は登録できないこと' do
        @user.email = 'testmail.com'
        expect(@user).to_not be_valid
      end

      # パスワード関連のバリデーション
      it 'パスワードが6文字未満では登録できないこと' do
        @user.password = '123ab'
        @user.password_confirmation = '123ab'
        expect(@user).to_not be_valid
      end

      it 'パスワードが数字のみでは登録できないこと' do
        @user.password = '123456'
        @user.password_confirmation = '123456'
        expect(@user).to_not be_valid
      end

      it 'パスワードが英字のみでは登録できないこと' do
        @user.password = 'abcdef'
        @user.password_confirmation = 'abcdef'
        expect(@user).to_not be_valid
      end

      it 'パスワードに全角文字が含まれる場合は登録できないこと' do
        @user.password = 'あ12345'
        @user.password_confirmation = 'あ12345'
        expect(@user).to_not be_valid
      end

      # 各必須項目が空のときに登録できないこと
      it 'last_nameが空では登録できないこと' do
        @user.last_name = nil
        expect(@user).to_not be_valid
      end

      it 'first_nameが空では登録できないこと' do
        @user.first_name = nil
        expect(@user).to_not be_valid
      end

      it 'last_name_kanaが空では登録できないこと' do
        @user.last_name_kana = nil
        expect(@user).to_not be_valid
      end

      it 'first_name_kanaが空では登録できないこと' do
        @user.first_name_kana = nil
        expect(@user).to_not be_valid
      end

      it 'birth_dateが空では登録できないこと' do
        @user.birth_date = nil
        expect(@user).to_not be_valid
      end

      # 氏名（漢字・ひらがな・カタカナ以外）のバリデーション
      it 'last_nameが全角（漢字・ひらがな・カタカナ）でなければ登録できないこと' do
        @user.last_name = 'tanaka'
        expect(@user).to_not be_valid
      end

      it 'first_nameが全角（漢字・ひらがな・カタカナ）でなければ登録できないこと' do
        @user.first_name = 'tarou'
        expect(@user).to_not be_valid
      end

      # フリガナ（全角カタカナ以外）のバリデーション
      it 'last_name_kanaが全角カタカナでなければ登録できないこと' do
        @user.last_name_kana = 'やまだ'
        expect(@user).to_not be_valid
      end

      it 'first_name_kanaが全角カタカナでなければ登録できないこと' do
        @user.first_name_kana = 'たろう'
        expect(@user).to_not be_valid
      end
    end
  end
end