# frozen_string_literal: true

RSpec.describe 'Projects requests', type: :request do
  let(:user) { create(:user) }
  let(:auth_token) { user.create_new_auth_token }
  let!(:project) { create(:project, user: user) }
  let(:valid_params) { { data: { attributes: { name: FFaker::Company.position } } } }
  let(:invalid_params) { { data: { attributes: { name: '' } } } }

  describe 'GET /api/v1/projects' do
    it 'returns Projects', :show_in_doc do
      get api_v1_projects_path, headers: auth_token

      expect(response.status).to eq 200
      expect(response).to match_response_schema('api/v1/projects/index')
    end

    it 'returns status 401: user unauthorized' do
      get api_v1_projects_path

      expect(response.status).to eq 401
    end
  end

  describe 'GET /api/v1/projects/id' do
    it 'returns Project', :show_in_doc do
      get api_v1_project_path(project), headers: auth_token

      expect(response.status).to eq 200
      expect(response).to match_response_schema('api/v1/projects/show')
    end
  end

  describe 'POST /api/v1/projects' do
    it 'create Project', :show_in_doc do
      post api_v1_projects_path, params: valid_params, headers: auth_token

      expect(response.status).to eq 201
      expect(response).to match_response_schema('api/v1/projects/show')
    end
  end

  describe 'PATCH /api/v1/projects/id' do
    it 'update Project', :show_in_doc do
      patch api_v1_project_path(project), params: valid_params, headers: auth_token

      expect(response.status).to eq 200
      expect(response).to match_response_schema('api/v1/projects/show')
    end
  end

  describe 'DELETE /api/v1/projects/id' do
    it 'delete Project', :show_in_doc do
      delete api_v1_project_path(project), headers: auth_token

      expect(response.status).to eq 204
    end
  end
end
