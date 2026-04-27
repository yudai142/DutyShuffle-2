# frozen_string_literal: true

class ShuffleOption < ApplicationRecord
  validates :reset_date, presence: { message: 'は必須です' }, 
                        uniqueness: { message: 'はすでに存在しています' }

  def self.current
    order(created_at: :desc).first
  end

  def self.reset_date
    current&.reset_date
  end
end
