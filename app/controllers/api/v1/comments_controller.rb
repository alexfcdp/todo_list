# frozen_string_literal: true

class Api::V1::CommentsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :task, only: %i[index create]
  load_and_authorize_resource :comment, through: :task, only: %i[index create]
  load_and_authorize_resource only: :destroy

  resource_description do
    formats ['json']
    error 401, 'Unauthorized'
    error 404, 'Not Found'
    error 422, 'Validation Error'
    error 500, 'Internal Server Error'
  end

  def_param_group :comment do
    param :task_id, :number, required: true
    param :data, Hash, required: true do
      param :attributes, Hash, required: true do
        param :commentary, String, required: true
        param :image, File
      end
    end
  end

  api :GET, '/v1/tasks/:task_id/comments', 'A list of Comments'
  param :task_id, :number, required: true
  def index
    render json: @comments
  end

  api :POST, '/v1/tasks/:task_id/comments', 'Creates a Comment'
  param_group :comment
  def create
    @comment = @task.comments.create(comment_params)
    if @comment.errors.blank?
      render json: @comment, status: :created
    else
      render json: { error: @comment.errors }, status: :unprocessable_entity
    end
  end

  api :DELETE, '/v1/comments/:id', 'Deletes the Comment'
  param :id, :number, required: true
  def destroy
    @comment.destroy
    head :no_content
  end

  private

  def comment_params
    params.require(:data).require(:attributes).permit(:commentary, :image)
  end
end
