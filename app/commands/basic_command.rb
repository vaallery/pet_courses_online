# frozen_string_literal: true

# Базовый класс для интеракторов
module BasicCommand
  class Failure < StandardError; end

  # ClassMethods
  module ClassMethods
    def call(*args, **kargs, &block)
      new(*args, **kargs).call(&block)
    end
  end

  def self.prepended(base)
    # See https://dry-rb.org/gems/dry-initializer/3.0/skip-undefined/
    base.extend Dry::Initializer[undefined: false]
    base.extend ClassMethods
  end

  attr_reader :errors

  def initialize(*args, **kargs)
    super(*args, **kargs)
    @errors = []
  end

  def call(&block)
    super(&block)
    self
  rescue Failure
    self
  end

  def success?
    !failure?
  end

  def failure?
    @errors.any?
  end

  private

  def fail!(messages = [])
    @errors += Array(messages)
    raise Failure
  end
end
