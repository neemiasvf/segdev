# frozen_string_literal: true

class BaseQuery
  attr_reader :params, :page, :per

  class << self
    def call(*args, &block)
      new(*args, &block).call
    end

    def call!(*args, &block)
      new(*args, &block).call!
    end
  end

  def initialize(params, *_args, &_block)
    @params = params
    @page = params[:page]
    @per = params[:per]
    @records = default_scope
  end

  def call(*args, &block)
    raise NotImplementedError, 'Subclasses must implement a call method'
  end

  def call!(*args, &block)
    raise NotImplementedError, 'Subclasses must implement a call! method'
  end

  private

  def default_scope
    raise NotImplementedError, 'Subclasses must define a default scope'
  end

  def paginate
    @records = @records.page(@page).per(@per)
  end
end
