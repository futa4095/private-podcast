# frozen_string_literal: true

class Group < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships
  has_many :channels
  has_one_attached :icon

  validates :name, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }
end
