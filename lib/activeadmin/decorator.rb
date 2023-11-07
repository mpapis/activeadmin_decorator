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
      def decorates_association(association, relation: association, with: nil)
        define_method(association) do
          associated =
            case relation
            when Symbol then model.send(relation)
            when Proc then relation.call(model)
            else raise ArgumentError, "relation must be a Symbol or Proc"
            end
          if associated.is_a?(ActiveRecord::Relation)
            with ||= decorator_class_name_for(associated.klass)
            with = with.constantize if with.is_a?(String)
            associated = associated.map { |item| with.new(item) }
          else
            with ||= decorator_class_name_for(associated.class)
            with = with.constantize if with.is_a?(String)
            associated = with.new(associated)
          end
          associated
        end
      end
    end

    def model = __getobj__

    def nil? = model.nil?

    private

    # autodetect decorator class name for association
    def decorator_class_name_for(klass)
      @prefix ||= self.class.name.split('::')[0...-1].freeze
      @suffix ||= self.class.name.split('::')[-1].sub(/^#{model.class.name}/, '').freeze
      [*@prefix, klass].join('::').concat(@suffix)
    end
  end
end
