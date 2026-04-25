# frozen_string_literal: true

class RemoveKanaFromMembers < ActiveRecord::Migration[7.1]
  def change
    remove_column :members, :kana, :string, null: false
  end
end
