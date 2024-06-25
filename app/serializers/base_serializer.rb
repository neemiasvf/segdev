# frozen_string_literal: true

class BaseSerializer < ActiveModel::Serializer
  def total_records
    object.size
  end
end
