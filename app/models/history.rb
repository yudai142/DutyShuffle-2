# frozen_string_literal: true

class History < ApplicationRecord
  belongs_to :work, optional: true
  belongs_to :member
  belongs_to :worksheet

  validates :date, presence: { message: 'は必須です' }
  validates :worksheet_id, presence: { message: 'は必須です' }
  validates :member_id, uniqueness: { scope: [:worksheet_id, :date], message: 'この日付には既に同じメンバーの記録があります' }

  scope :by_date, ->(date) { where(date: date) }
  scope :by_month, lambda { |year, month|
    where('EXTRACT(YEAR FROM date) = ? AND EXTRACT(MONTH FROM date) = ?', year, month)
  }
  scope :recent, -> { order(date: :desc) }
end
