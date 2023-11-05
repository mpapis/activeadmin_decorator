# frozen_string_literal: true

require_relative 'decorator'

module ActiveAdmin
  class ArbreDecorator < Decorator
    include ActiveAdmin::ViewHelpers
    include ActionView::Helpers

    CONFLICTING_METHODS = %i[display_name title].freeze

    def initialize(obj)
      super
      singleton_class.include Rails.application.routes.url_helpers
      CONFLICTING_METHODS.each do |method|
        define_singleton_method(method) { obj.send(method) } if !custom_method?(method) && obj.respond_to?(method)
      end
    end

    ruby2_keywords def method_missing(method, *args, &block)
      if cached_arbre_element.respond_to?(method) && !model.respond_to?(method)
        Arbre::Context.new(model:) do
          __send__(method, *args, &block)
        end
      else
        super
      end
    end

    def respond_to?(method, include_private = false)
      return false if CONFLICTING_METHODS.include?(method) && !model.respond_to?(method) && !custom_method?(method)

      super
    end

    private

    def cached_arbre_element
      @cached_arbre_element ||= Arbre::Element.new
    end

    def custom_method?(method_name)
      methods.include?(method_name) && method(method_name).owner < ArbreDecorator
    end
  end
end
