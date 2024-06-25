# frozen_string_literal: true

class BaseUseCase
  attr_reader :params

  class << self
    def call(*args, &block)
      new(*args, &block).call
    end

    def call!(*args, &block)
      new(*args, &block).call!
    end
  end

  def initialize(params, *_args, &_block)
    @params = params.as_json.with_indifferent_access
  end

  def call(*args, &block)
    raise NotImplementedError, 'Subclasses must implement a call method'
  end

  def call!(*args, &block)
    raise NotImplementedError, 'Subclasses must implement a call! method'
  end
end
