# frozen_string_literal: true

RSpec.describe 'Tasks requests', type: :request do
  let(:user) { create(:user) }
  let(:auth_token) { user.create_new_auth_token }
  let(:project) { create(:project, user: user) }
  let!(:task) { create(:task, project: project) }
  let(:valid_params) { { data: { attributes: { name: FFaker::Skill.tech_skill } } } }
  let(:invalid_params) { { data: { attributes: { name: '' } } } }

  describe 'GET /api/v1/projects/:project_id/tasks' do
    it 'returns Tasks', :show_in_doc do
      get api_v1_project_tasks_path(project), headers: auth_token

      expect(response.status).to eq 200
      expect(response).to match_response_schema('api/v1/tasks/index')
    end
  end

  describe 'GET /api/v1/tasks/:id' do
    it 'returns Tasks', :show_in_doc do
      get api_v1_task_path(task), headers: auth_token

      expect(response.status).to eq 200
      expect(response).to match_response_schema('api/v1/tasks/show')
    end
  end

  describe 'POST /api/v1/projects/:project_id/tasks ' do
    it 'returns Tasks', :show_in_doc do
      post api_v1_project_tasks_path(project), params: valid_params, headers: auth_token

      expect(response.status).to eq 201
      expect(response).to match_response_schema('api/v1/tasks/show')
    end
  end

  describe 'PATCH /api/v1/tasks/:id' do
    it 'returns Tasks', :show_in_doc do
      patch api_v1_task_path(task), params: valid_params, headers: auth_token

      expect(response.status).to eq 200
      expect(response).to match_response_schema('api/v1/tasks/show')
    end
  end

  describe 'DELETE /api/v1/tasks/:id' do
    it 'returns Tasks', :show_in_doc do
      delete api_v1_task_path(task), headers: auth_token

      expect(response.status).to eq 204
    end
  end

  describe 'PATCH /api/v1/tasks/:id/complete' do
    it 'returns Tasks', :show_in_doc do
      patch complete_api_v1_task_path(task), params: { data: { attributes: { done: true } } }, headers: auth_token

      expect(response.status).to eq 200
      expect(response).to match_response_schema('api/v1/tasks/show')
    end
  end

  describe 'PATCH /api/v1/tasks/:id/position' do
    it 'returns Tasks', :show_in_doc do
      patch position_api_v1_task_path(task), params: { data: { attributes: { position: 3 } } }, headers: auth_token

      expect(response.status).to eq 200
      expect(response).to match_response_schema('api/v1/tasks/show')
    end
  end
end
