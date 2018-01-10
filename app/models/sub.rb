class Sub < ApplicationRecord
  validates :title, :description, presence: true

  belongs_to :mod,
  foreign_key: :mod_id,
  class_name: :User

  has_many :post_subs, inverse_of: :sub, dependent: :destroy
  has_many :posts, through: :post_subs, source: :post
end
