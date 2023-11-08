# frozen_string_literal: true

module ActiveAdmin
  class Decorator < SimpleDelegator
    module Association
      class << self
        def decorate(association, with: nil, parent: nil)
          raise ArgumentError, "parent or with required" if parent.nil? && with.nil?

          if association.nil?
            nil
          elsif association.respond_to?(:each)
            decorate_many(association, with, parent)
          else
            decorate_one(association, with, parent)
          end
        end

        def decorate_many(association, with, parent)
          with ||=
            if association.is_a?(ActiveRecord::Relation)
              decorator_class_name_for(parent, association.klass)
            else
              decorator_class_name_for(parent, association.first.class)
            end
          with = with.constantize if with.is_a?(String)
          association.map { |item| with.new(item) }
        end

        def decorate_one(element, with, parent)
          with ||= decorator_class_name_for(parent, element.class)
          with = with.constantize if with.is_a?(String)
          with.new(element)
        end

        def decorator_class_name_for(parent, klass)
          parent_class_elements = parent.class.name.split("::")
          prefix = parent_class_elements[0...-1]
          suffix = parent_class_elements[-1].sub(/^#{parent.model.class.name}/, "")
          [*prefix, klass].join("::").concat(suffix)
        end
      end
    end
  end
end
