# frozen_string_literal: true

RSpec.describe 'Comments requests', type: :request do
  let(:user) { create(:user) }
  let(:auth_token) { user.create_new_auth_token }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }
  let!(:comment) { create(:comment, task: task) }
  let(:valid_params) { { data: { attributes: { commentary: FFaker::AWS.product_description } } } }
  let(:invalid_params) { { data: { attributes: { commentary: '' } } } }

  describe 'GET /api/v1/tasks/:task_id/comments' do
    it 'returns Comments', :show_in_doc do
      get api_v1_task_comments_path(task), headers: auth_token

      expect(response.status).to eq 200
      expect(response).to match_response_schema('api/v1/comments/index')
    end
  end

  describe 'POST /api/v1/tasks/:task_id/comments' do
    it 'returns Comments', :show_in_doc do
      post api_v1_task_comments_path(task), params: valid_params, headers: auth_token

      expect(response.status).to eq 201
      expect(response).to match_response_schema('api/v1/comments/show')
    end
  end

  describe 'DELETE /api/v1/comments/:id' do
    it 'returns Comments', :show_in_doc do
      delete api_v1_comment_path(comment), headers: auth_token

      expect(response.status).to eq 204
    end
  end
end
