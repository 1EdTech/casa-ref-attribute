require 'casa/attribute/strategy/base'

module CASA
  module Attribute
    module Strategy
      module Filter
        class AlwaysAccept < ::CASA::Attribute::Strategy::Base

          def process payload

            true

          end

        end
      end
    end
  end
end