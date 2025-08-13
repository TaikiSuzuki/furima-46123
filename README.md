# README

# テーブル設計
| テーブル名              | 概要                                 |
| :-----------           | :------------------------------------|
| `users`                | ユーザー情報を管理する                 |
| `items`                | 商品情報を管理する                     |
| `comments`             | 商品へのをコメントを管理する            |
| `purchases`            | 購入記録を管理する                     |
| `shipping addresses`   | 発送先情報を管理する                   |


## usersテーブル

| Column              | Type       | Options                        |
| ------------------- | ---------- | ------------------------------ |
| nickname            | string     | null: false                    |
| email               | string     | null: false, unique: true      |
| encrypted_password  | string     | null: false                    |
| first_name          | string     | null: false                    |
| last_name           | string     | null: false                    |
| first_name_kana     | string     | null: false                    |
| last_name_kana      | string     | null: false                    |
| birth_date          | date       | null: false                    |


### Association
- has_many :items
- has_many :purchases
- has_many :comments

## itemsテーブル

| Column                | Type       | Options                        |
| -------------------   | ---------- | ------------------------------ |
| name                  | string     | null: false                    |
| description           | text       | null: false                    |
| price                 | integer    | null: false                    |
| category_id           | integer    | null: false                    |
| condition_id          | integer    | null: false                    |
| shipping_fee_payer_id | integer    | null: false                    |
| days_to_ship_id       | integer    | null: false                    |
| user_id               | integer    | null: false                    |

### Association

- belongs_to :users
- has_one :purchases
- has_many :comments


## commentsテーブル

| Column     | Type       | Options                        |
| -------    | ---------- | ------------------------------ |
| content    | text       | null: false                    |
| user_id    | integer    | null: false, foreign_key: true |
| item_id    | integer    | null: false, foreign_key: true |


### Association
- belongs_to :users
- belongs_to :items

## purchasesテーブル

| Column     | Type       | Options                        |
| -------    | ---------- | ------------------------------ |
| user_id    | integer    | null: false, foreign_key: true |
| item_id    | integer    | null: false, foreign_key: true |


### Association
- belongs_to :users
- belongs_to :items
- has_one :shipping_address


## shipping_addressテーブル

| Column                | Type       | Options                        |
| -------               | ---------- | ------------------------------ |
| postal_code           | string     | null: false                    |
| prefecture_id         | integer    | null: false, foreign_key: tru  |
| city                  | string     | null: false                    |
| address               | string     | null: false                    |
| building              | string     | null: false                    |
| phone_number          | string     | null: false                    |
| purchase_id           | string     | null: false, foreign_key: true |


### Association
- belongs_to :purchases
