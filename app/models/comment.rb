# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :task, counter_cache: true
  has_one_attached :image

  validates :commentary, length: { minimum: 10, maximum: 256 }, presence: true
  validates :image, size: { less_than: 10.megabytes, message: I18n.t('errors.file_size') + '%{count}' },
                    content_type: { in: %w[image/png image/jpg image/jpeg], message: I18n.t('errors.file_content') }
end
