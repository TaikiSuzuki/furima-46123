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
        @user.valid?
        expect(@user.errors.full_messages).to include("Nickname can't be blank")
      end
      
      it 'emailが空では登録できないこと' do
        @user.email = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Email can't be blank")
      end
      
      it 'passwordが空では登録できないこと' do
        @user.password = nil
        @user.password_confirmation = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end

      # パスワード関連のバリデーション
      it 'パスワードが6文字未満では登録できないこと' do
        @user.password = '123ab'
        @user.password_confirmation = '123ab'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
      end

      it 'password_confirmationがpasswordと一致しない場合は登録できないこと' do
        @user.password = '123456'
        @user.password_confirmation = '1234567'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
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
        @user.valid?
        expect(@user.errors.full_messages).to include("Email is invalid")
      end

      it 'パスワードが数字のみでは登録できないこと' do
        @user.password = '123456'
        @user.password_confirmation = '123456'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password は半角英数字混合で設定してください")
      end

      it 'パスワードが英字のみでは登録できないこと' do
        @user.password = 'abcdef'
        @user.password_confirmation = 'abcdef'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password は半角英数字混合で設定してください")
      end

      it 'パスワードに全角文字が含まれる場合は登録できないこと' do
        @user.password = 'あ12345'
        @user.password_confirmation = 'あ12345'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password は半角英数字混合で設定してください")
      end

      # 各必須項目が空のときに登録できないこと
      it 'last_nameが空では登録できないこと' do
        @user.last_name = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name can't be blank")
      end

      it 'first_nameが空では登録できないこと' do
        @user.first_name = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("First name can't be blank")
      end

      it 'last_name_kanaが空では登録できないこと' do
        @user.last_name_kana = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name kana can't be blank")
      end

      it 'first_name_kanaが空では登録できないこと' do
        @user.first_name_kana = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("First name kana can't be blank")
      end

      it 'birth_dateが空では登録できないこと' do
        @user.birth_date = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Birth date can't be blank")
      end

      # 氏名（漢字・ひらがな・カタカナ以外）のバリデーション
      it 'last_nameが全角（漢字・ひらがな・カタカナ）でなければ登録できないこと' do
        @user.last_name = 'tanaka'
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name は全角（漢字・ひらがな・カタカナ）で入力してください")
      end

      it 'first_nameが全角（漢字・ひらがな・カタカナ）でなければ登録できないこと' do
        @user.first_name = 'tarou'
        @user.valid?
        expect(@user.errors.full_messages).to include("First name は全角（漢字・ひらがな・カタカナ）で入力してください")
      end

      # フリガナ（全角カタカナ以外）のバリデーション
      it 'last_name_kanaが全角カタカナでなければ登録できないこと' do
        @user.last_name_kana = 'やまだ'
        @user.valid?
        expect(@user.errors.full_messages).to include("Last name kana は全角カタカナで入力してください")
      end

      it 'first_name_kanaが全角カタカナでなければ登録できないこと' do
        @user.first_name_kana = 'たろう'
        @user.valid?
        expect(@user.errors.full_messages).to include("First name kana は全角カタカナで入力してください")
      end
    end
  end
end
