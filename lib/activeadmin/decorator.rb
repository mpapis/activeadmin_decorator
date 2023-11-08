# frozen_string_literal: true

require "delegate"
require_relative "decorator/association"

module ActiveAdmin
  class Decorator < SimpleDelegator
    class << self
      # Utility method for ActiveAdmin
      def decorate(*args)
        object = args[0]
        Association.decorate(object, with: self)
      end

      # use in decorator to decorate association
      def decorates_association(association, relation: association, with: nil) # rubocop:disable Metrics/MethodLength
        raise ArgumentError, "relation must be a Symbol or Proc" unless relation.is_a?(Symbol) || relation.is_a?(Proc)

        define_method(association) do
          if instance_variable_defined?("@#{association}_decorated")
          then instance_variable_get("@#{association}_decorated")
          else
            result =
              if relation.is_a?(Proc) then relation.call(model)
              elsif relation.is_a?(Symbol) then model.send(relation)
              end
            instance_variable_set("@#{association}_decorated", Association.decorate(result, with:, parent: self))
          end
        end
      end
    end

    def model = __getobj__

    def nil? = model.nil?
  end
end
