# frozen_string_literal: true

class TaskSerializer < ActiveModel::Serializer
  attributes :id, :name, :position, :done, :deadline, :comments_count
  belongs_to :project
  has_many :comments

  link(:self) { api_v1_task_url(object) }
end
