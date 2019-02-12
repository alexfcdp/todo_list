# frozen_string_literal: true

RSpec.describe 'Tasks requests', type: :request do
  let(:user) { create(:user) }
  let(:auth_token) { user.create_new_auth_token }
  let(:project) { create(:project, user: user) }
  let!(:task) { create(:task, project: project) }
  let(:valid_params) { { data: { attributes: { name: FFaker::Skill.tech_skill } } } }
  let(:invalid_params) { { data: { attributes: { name: '' } } } }

  describe 'GET /api/v1/projects/:project_id/tasks' do
    it 'returns project tasks', :show_in_doc do
      get api_v1_project_tasks_path(project), headers: auth_token

      expect(response.status).to eq 200
      expect(response).to match_response_schema('api/v1/tasks/index')
    end

    it 'returns status 401: user unauthorized' do
      get api_v1_project_tasks_path(project)

      expect(response.status).to eq 401
    end

    it 'returns status 404' do
      get api_v1_project_tasks_path(9999), headers: auth_token

      expect(response.status).to eq 404
    end
  end

  describe 'GET /api/v1/tasks/:id' do
    it 'returns project task', :show_in_doc do
      get api_v1_task_path(task), headers: auth_token

      expect(response.status).to eq 200
      expect(response).to match_response_schema('api/v1/tasks/show')
    end

    it 'returns http status: 404' do
      get api_v1_task_path(999), headers: auth_token

      expect(response.status).to eq 404
    end

    it 'returns status 401: user unauthorized' do
      get api_v1_task_path(task)

      expect(response.status).to eq 401
    end
  end

  describe 'POST /api/v1/projects/:project_id/tasks ' do
    it 'returns created project task', :show_in_doc do
      post api_v1_project_tasks_path(project), params: valid_params, headers: auth_token

      expect(response.status).to eq 201
      expect(response).to match_response_schema('api/v1/tasks/show')
    end

    it 'returns http status: 422' do
      post api_v1_project_tasks_path(project), params: invalid_params, headers: auth_token

      expect(response.status).to eq 422
    end

    it 'creates task' do
      expect do
        post api_v1_project_tasks_path(project), params: valid_params, headers: auth_token
      end.to change(Task, :count).by(1)
    end

    it 'data not valid, task not created' do
      expect do
        post api_v1_project_tasks_path(project), params: invalid_params, headers: auth_token
      end.to change(Task, :count).by(0)
    end

    it 'returns http status: 404' do
      post api_v1_project_tasks_path(999), params: valid_params, headers: auth_token

      expect(response.status).to eq 404
    end

    it 'returns status 401: user unauthorized' do
      post api_v1_project_tasks_path(project), params: valid_params

      expect(response.status).to eq 401
    end
  end

  describe 'PATCH /api/v1/tasks/:id' do
    let!(:deadline) { Time.zone.now.strftime('%Y-%m-%d %H:%M:%S') }
    let(:full_params) { { data: { attributes: { name: 'Update deadline', position: 5, deadline: deadline } } } }

    it 'returns updated project task' do
      patch api_v1_task_path(task), params: valid_params, headers: auth_token

      expect(response.status).to eq 200
      expect(response).to match_response_schema('api/v1/tasks/show')
    end

    it 'returns updated task fields', :show_in_doc do
      patch api_v1_task_path(task), params: full_params, headers: auth_token

      task.reload
      expect(task.name).to eq('Update deadline')
      expect(task.position).to eq(5)
      expect(task.deadline).to eq(deadline)
    end

    it 'return Not Found' do
      patch api_v1_task_path(999), params: valid_params, headers: auth_token

      expect(response.status).to eq 404
    end

    it 'returns http status 422' do
      patch api_v1_task_path(task), params: invalid_params, headers: auth_token

      expect(response.status).to eq 422
    end

    it 'returns status 401: user unauthorized' do
      patch api_v1_task_path(task), params: valid_params

      expect(response.status).to eq 401
    end
  end

  describe 'DELETE /api/v1/tasks/:id' do
    it 'returns http status 204', :show_in_doc do
      delete api_v1_task_path(task), headers: auth_token

      expect(response.status).to eq 204
    end

    it 'removes task' do
      expect do
        delete api_v1_task_path(task), headers: auth_token
      end.to change(Task, :count).from(1).to(0)
    end

    it 'returns status 401: user unauthorized' do
      delete api_v1_task_path(task)

      expect(response.status).to eq 401
    end

    it 'returns status 404' do
      delete api_v1_task_path(999), headers: auth_token

      expect(response.status).to eq 404
    end
  end

  describe 'PATCH /api/v1/tasks/:id/complete' do
    it 'returns task with status completed', :show_in_doc do
      patch complete_api_v1_task_path(task), headers: auth_token

      expect(response.status).to eq 200
      expect(response).to match_response_schema('api/v1/tasks/show')
    end

    it 'returns task completed' do
      patch complete_api_v1_task_path(task), headers: auth_token

      task.reload
      expect(task.done).to be true
    end

    it 'return Not Found' do
      patch complete_api_v1_task_path(999), headers: auth_token

      expect(response.status).to eq 404
    end

    it 'returns status 401: user unauthorized' do
      patch complete_api_v1_task_path(task)

      expect(response.status).to eq 401
    end
  end

  describe 'PATCH /api/v1/tasks/:id/position' do
    let(:params) { { data: { attributes: { position: 3 } } } }

    it 'returns updated position task', :show_in_doc do
      patch position_api_v1_task_path(task), params: params, headers: auth_token

      expect(response.status).to eq 200
      expect(response).to match_response_schema('api/v1/tasks/show')
    end

    it 'returns position of task' do
      patch position_api_v1_task_path(task), params: params, headers: auth_token

      task.reload
      expect(task.position).to eq(3)
    end

    it 'return Not Found' do
      patch position_api_v1_task_path(888), params: params, headers: auth_token

      expect(response.status).to eq 404
    end

    it 'returns status 401: user unauthorized' do
      patch position_api_v1_task_path(task), params: params

      expect(response.status).to eq 401
    end
  end
end
