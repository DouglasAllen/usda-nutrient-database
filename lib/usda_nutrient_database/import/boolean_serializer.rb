module UsdaNutrientDatabase
  module Import
    module BooleanSerializer
      def self.serialize(value)
        value.to_s =~ /^(1|t|y)$/i
      end
    end
  end
end
