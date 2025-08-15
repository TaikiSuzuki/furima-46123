# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    # すべての項目が正しく入力されていれば有効
    it 'is valid with all required attributes' do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end

    # 必須項目のテスト
    it 'is not valid without a nickname' do
      user = FactoryBot.build(:user, nickname: nil)
      expect(user).to_not be_valid
    end

    it 'is not valid without an email' do
      user = FactoryBot.build(:user, email: nil)
      expect(user).to_not be_valid
    end

    it 'is not valid without a password' do
      user = FactoryBot.build(:user, password: nil)
      expect(user).to_not be_valid
    end

    # パスワードのバリデーション
    it 'is not valid with a password shorter than 6 characters' do
      user = FactoryBot.build(:user, password: '123ab')
      expect(user).to_not be_valid
    end

    it 'is not valid with a password that is not a mix of numbers and letters' do
      user = FactoryBot.build(:user, password: 'abcdef')
      expect(user).to_not be_valid
    end

    # 氏名（全角）のバリデーション
    it 'is not valid with non-kanji/hiragana/katakana last_name' do
      user = FactoryBot.build(:user, last_name: 'tanaka')
      expect(user).to_not be_valid
    end

    # フリガナ（全角カタカナ）のバリデーション
    it 'is not valid with non-katakana last_name_kana' do
      user = FactoryBot.build(:user, last_name_kana: 'やまだ')
      expect(user).to_not be_valid
    end
  end
end