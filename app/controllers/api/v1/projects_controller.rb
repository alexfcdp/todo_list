# frozen_string_literal: true

class Api::V1::ProjectsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  resource_description do
    formats ['json']
    error 401, 'Unauthorized'
    error 404, 'Not Found'
    error 422, 'Validation Error'
    error 500, 'Internal Server Error'
  end

  def_param_group :project do
    param :data, Hash, required: true do
      param :attributes, Hash, required: true do
        param :name, String, required: true
      end
    end
  end

  api :GET, '/v1/projects', 'A list of Projects'
  def index
    render json: @projects
  end

  api :GET, '/v1/projects/:id', 'Shows the Project'
  param :id, :number, required: true
  def show
    render json: @project
  end

  api :POST, '/v1/projects', 'Creates a Project'
  param_group :project
  def create
    @project = current_user.projects.create(project_params)
    if @project.errors.blank?
      render json: @project, status: :created
    else
      render json: { error: @project.errors }, status: :unprocessable_entity
    end
  end

  api :PATCH, '/v1/projects/:id', 'Updates the Project'
  param :id, :number, required: true
  param_group :project
  def update
    if @project.update(project_params)
      render json: @project, status: :ok
    else
      render json: { error: @project.errors }, status: :unprocessable_entity
    end
  end

  api :DELETE, '/v1/projects/:id', 'Deletes the Project'
  param :id, :number, required: true
  def destroy
    @project.destroy
    head :no_content
  end

  private

  def project_params
    params.require(:data).require(:attributes).permit(:name)
  end
end
