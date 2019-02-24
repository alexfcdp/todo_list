# frozen_string_literal: true

class CommentSerializer < ActiveModel::Serializer
  attributes :id, :commentary, :image
  belongs_to :task

  def image
    rails_blob_path(object.image, only_path: true) if object.image.attached?
  end

  link(:self) { api_v1_comment_url(object) }
end
