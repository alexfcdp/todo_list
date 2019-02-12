# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found
    render json: { message: I18n.t('exception.record_not_found') },
           status: :not_found
  end
end
