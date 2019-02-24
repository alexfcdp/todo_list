# frozen_string_literal: true

RSpec.describe 'Projects requests', type: :request do
  let(:user) { create(:user) }
  let(:auth_token) { user.create_new_auth_token }
  let!(:project) { create(:project, user: user) }
  let(:valid_params) { { data: { attributes: { name: FFaker::Company.position } } } }
  let(:invalid_params) { { data: { attributes: { name: '' } } } }

  describe 'GET /api/v1/projects' do
    it 'returns user projects', :show_in_doc do
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
    it 'returns user project', :show_in_doc do
      get api_v1_project_path(project), headers: auth_token

      expect(response.status).to eq 200
      expect(response).to match_response_schema('api/v1/projects/show')
    end

    it 'returns http status: 404' do
      get api_v1_project_path(999), headers: auth_token

      expect(response.status).to eq 404
    end

    it 'returns status 401: user unauthorized' do
      get api_v1_project_path(project)

      expect(response.status).to eq 401
    end
  end

  describe 'POST /api/v1/projects' do
    it 'returns created user project', :show_in_doc do
      post api_v1_projects_path, params: valid_params, headers: auth_token

      expect(response.status).to eq 201
      expect(response).to match_response_schema('api/v1/projects/show')
    end

    it 'returns http status: 422' do
      post api_v1_projects_path, params: invalid_params, headers: auth_token

      expect(response.status).to eq 422
    end

    it 'creates project' do
      expect do
        post api_v1_projects_path, params: valid_params, headers: auth_token
      end.to change(Project, :count).by(1)
    end

    it 'data not valid, project not created' do
      expect do
        post api_v1_projects_path, params: invalid_params, headers: auth_token
      end.to change(Project, :count).by(0)
    end

    it 'returns status 401: user unauthorized' do
      post api_v1_projects_path, params: valid_params

      expect(response.status).to eq 401
    end
  end

  describe 'PATCH /api/v1/projects/id' do
    it 'returns updated user project', :show_in_doc do
      patch api_v1_project_path(project), params: valid_params, headers: auth_token

      expect(response.status).to eq 200
      expect(response).to match_response_schema('api/v1/projects/show')
    end

    it 'return Not Found' do
      patch api_v1_project_path(888), params: invalid_params, headers: auth_token

      expect(response.status).to eq 404
    end

    it 'returns http status 422' do
      patch api_v1_project_path(project), params: invalid_params, headers: auth_token

      expect(response.status).to eq 422
    end

    it 'returns status 401: user unauthorized' do
      patch api_v1_project_path(project), params: valid_params

      expect(response.status).to eq 401
    end
  end

  describe 'DELETE /api/v1/projects/id' do
    it 'returns http status 204', :show_in_doc do
      delete api_v1_project_path(project), headers: auth_token

      expect(response.status).to eq 204
    end

    it 'removes project' do
      expect do
        delete api_v1_project_path(project), headers: auth_token
      end.to change(Project, :count).from(1).to(0)
    end

    it 'returns status 401: user unauthorized' do
      delete api_v1_project_path(project)

      expect(response.status).to eq 401
    end

    it 'returns status 404' do
      delete api_v1_project_path(999), headers: auth_token

      expect(response.status).to eq 404
    end
  end
end
