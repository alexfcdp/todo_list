# frozen_string_literal: true

class Project < ApplicationRecord
  with_options inverse_of: :project do
    has_many :tasks, -> { order(position: :asc) }, dependent: :destroy
  end
  belongs_to :user

  validates :name, presence: true, uniqueness: true
end
