# frozen_string_literal: true

require_relative "decorator"

module ActiveAdmin
  class ArbreDecorator < Decorator
    include ActionView::Helpers
    include Arbre::Element::BuilderMethods

    def initialize(obj)
      super
      singleton_class.include Rails.application.routes.url_helpers
    end

    private

    def arbre_context = @arbre_context ||= Arbre::Context.new
  end
end
