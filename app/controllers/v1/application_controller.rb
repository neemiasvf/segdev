# frozen_string_literal: true

module V1
  class ApplicationController < ActionController::API
    before_action do
      # reference: https://github.com/rails-api/active_model_serializers/blob/0-10-stable/docs/general/rendering.md#namespace
      self.namespace_for_serializer = V1
    end
  end
end
