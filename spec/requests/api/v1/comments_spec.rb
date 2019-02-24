# frozen_string_literal: true

RSpec.describe 'Comments requests', type: :request do
  let(:user) { create(:user) }
  let(:auth_token) { user.create_new_auth_token }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }
  let!(:comment) { create(:comment, task: task) }
  let(:valid_params) { { data: { attributes: { commentary: FFaker::Lorem.sentence } } } }
  let(:invalid_params) { { data: { attributes: { commentary: '' } } } }

  describe 'GET /api/v1/tasks/:task_id/comments' do
    it 'returns task comments', :show_in_doc do
      get api_v1_task_comments_path(task), headers: auth_token

      expect(response.status).to eq 200
      expect(response).to match_response_schema('api/v1/comments/index')
    end

    it 'returns status 401: user unauthorized' do
      get api_v1_task_comments_path(task)

      expect(response.status).to eq 401
    end

    it 'returns status 404' do
      get api_v1_task_comments_path(999), headers: auth_token

      expect(response.status).to eq 404
    end
  end

  describe 'POST /api/v1/tasks/:task_id/comments' do
    it 'returns created task comment', :show_in_doc do
      post api_v1_task_comments_path(task), params: valid_params, headers: auth_token

      expect(response.status).to eq 201
      expect(response).to match_response_schema('api/v1/comments/show')
    end

    it 'returns http status: 422' do
      post api_v1_task_comments_path(task), params: invalid_params, headers: auth_token

      expect(response.status).to eq 422
    end

    it 'creates comment to task' do
      expect do
        post api_v1_task_comments_path(task), params: valid_params, headers: auth_token
      end.to change(Comment, :count).by(1)
    end

    it 'data not valid, comment not created' do
      expect do
        post api_v1_task_comments_path(task), params: invalid_params, headers: auth_token
      end.to change(Comment, :count).by(0)
    end

    it 'returns status 401: user unauthorized' do
      post api_v1_task_comments_path(task), params: valid_params

      expect(response.status).to eq 401
    end
  end

  describe 'DELETE /api/v1/comments/:id' do
    it 'returns http status 204', :show_in_doc do
      delete api_v1_comment_path(comment), headers: auth_token

      expect(response.status).to eq 204
    end

    it 'removes comment' do
      expect do
        delete api_v1_comment_path(comment), headers: auth_token
      end.to change(Comment, :count).from(1).to(0)
    end

    it 'returns status 401: user unauthorized' do
      delete api_v1_comment_path(comment)

      expect(response.status).to eq 401
    end

    it 'returns status 404' do
      delete api_v1_comment_path(999), headers: auth_token

      expect(response.status).to eq 404
    end
  end
end
