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
        @source_name = lead.source.name
        return_source
      end

      def return_source
        return "#{@source_name} - Revisão" if product_name['revisão']

        @source_name = choose_dealership
        return "#{@source_name} - Consórcio" if description['consórcio']

        @source_name
      end

      def choose_dealership
        if message['1709446']
          "#{@source_name} - Ilha"
        elsif message['1699751']
          "#{@source_name} - SJ"
        else
          @source_name
        end
      end

      def product_name
        @lead.product.name.downcase
      end

      def message
        @lead.message || ''
      end

      def description
        @lead.description&.downcase || ''
      end
    end
  end
end
