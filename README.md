# README

# テーブル設計
| テーブル名              | 概要                                 |
| :-----------           | :----------------------------------- |
| `users`                | ユーザー情報を管理する                 |
| `items`                | 商品情報を管理する                     |
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


## itemsテーブル

| Column                | Type       | Options                        |
| -------------------   | ---------- | ------------------------------ |
| name                  | string     | null: false                    |
| description           | text       | null: false                    |
| price                 | integer    | null: false                    |
| category_id           | integer    | null: false                    |
| condition_id          | integer    | null: false                    |
| shipping_fee_payer_id | integer    | null: false                    |
| shipping_from_id      | integer    | null: false                    |
| days_to_ship_id       | integer    | null: false                    |
| user                  | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- has_one :purchase




## purchasesテーブル

| Column     | Type       | Options                        |
| -------    | ---------- | ------------------------------ |
| user       | references | null: false, foreign_key: true |
| item       | references | null: false, foreign_key: true |


### Association
- belongs_to :user
- belongs_to :item
- has_one :shipping_address


## shipping_addressテーブル

| Column                | Type       | Options                        |
| -------               | ---------- | ------------------------------ |
| postal_code           | string     | null: false                    |
| shipping_from_id      | integer    | null: false                    |
| genre_id              | integer    | null: false                    |
| city                  | string     | null: false                    |
| address               | string     | null: false                    |
| building              | string     |                                |
| phone_number          | string     | null: false                    |
| purchase              | references | null: false, foreign_key: true |


### Association
- belongs_to :purchase
