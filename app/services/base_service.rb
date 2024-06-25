# frozen_string_literal: true

class BaseService
  class << self
    def call(*args, &block)
      new(*args, &block).call
    end

    def call!(*args, &block)
      new(*args, &block).call!
    end
  end

  def initialize(*_args, &_block)
    raise NotImplementedError, 'Subclasses must implement an initialize method'
  end

  def call(*args, &block)
    raise NotImplementedError, 'Subclasses must implement a call method'
  end

  def call!(*args, &block)
    raise NotImplementedError, 'Subclasses must implement a call! method'
  end
end
