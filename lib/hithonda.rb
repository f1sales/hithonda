# frozen_string_literal: true

require_relative 'hithonda/version'
require 'f1sales_custom/parser'
require 'f1sales_custom/source'
require 'f1sales_custom/hooks'

module Hithonda
  class Error < StandardError; end

  class F1SalesCustom::Hooks::Lead
    def self.switch_source(lead)
      source_name = lead.source.name
      product_name = lead.product.name.downcase
      message = lead.message || ''
      if message['1709446']
        "#{source_name} - Ilha"
      elsif message['1699751']
        "#{source_name} - SJ"
      elsif product_name['revisão']
        'Fonte sem time'
      else
        source_name
      end
    end
  end
end
