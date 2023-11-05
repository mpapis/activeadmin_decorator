# frozen_string_literal: true

require 'delegate'

module ActiveAdmin
  class Decorator < SimpleDelegator
    class << self
      # Utility method for ActiveAdmin
      def decorate(*args)
        object = args[0]
        if object.is_a?(Enumerable)
          object.map { |o| new(o) }
        else
          new(object)
        end
      end

      # use in decorator to decorate association
      def decorates_association(association, relation: association, with: "Decorators::#{association.to_s.singularize.classify}")
        define_method(association) do
          associated =
            case relation
            when Symbol then model.send(relation)
            when Proc then relation.call(model)
            else raise ArgumentError, "relation must be a Symbol or Proc"
            end
          with = with.constantize if with.is_a?(String)
          if associated.is_a?(ActiveRecord::Relation)
            associated = associated.map { |item| with.new(item) }
          else
            associated = with.new(associated)
          end
          associated
        end
      end
    end

    def model = __getobj__

    def nil? = model.nil?
  end
end
