# frozen_string_literal: true

class Task < ApplicationRecord
  has_many :comments, dependent: :destroy
  belongs_to :project

  acts_as_list scope: :project

  validates :name, presence: true
  validates :position, numericality: { only_integer: true }
  validates :done, inclusion: { in:  [true, false] }
end
