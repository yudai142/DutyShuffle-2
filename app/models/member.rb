# frozen_string_literal: true

class Member < ApplicationRecord
  belongs_to :worksheet

  has_many :member_options, dependent: :destroy
  has_many :works, through: :member_options
  has_many :histories, dependent: :destroy

  validates :name, presence: { message: 'は必須です' }
  validates :name, length: { maximum: 255, message: 'は255文字以内でお願いします' }

  scope :active, -> { where(archive: false) }
  scope :archived, -> { where(archive: true) }

  # 過去の互換性のためのメソッド
  def full_name
    name
  end
end
