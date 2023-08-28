# frozen_string_literal: true

require_relative 'hithonda/version'
require 'f1sales_custom/parser'
require 'f1sales_custom/source'
require 'f1sales_custom/hooks'

module Hithonda
  class Error < StandardError; end

  class F1SalesCustom::Hooks::Lead
    class << self
      def switch_source(lead)
        @lead = lead
        return_source
      end

      private

      def return_source
        return "#{source_name} - Revisão" if revision?

        return "#{source_name} - Consórcio" if consortium?

        source_name
      end

      def product_name
        @lead.product.name.downcase
      end

      def description
        @lead.description&.downcase || ''
      end

      def source_name
        @lead.source.name
      end

      def consortium?
        description['consórcio'] || description['hsf']
      end

      def revision?
        product_name['revisão']
      end
    end
  end
end
