module UsdaNutrientDatabase
  module Import
    class Weights
      FileImporter.register_file(self)

      def filename
        'WEIGHT.txt'
      end

      def column_names
        [
          :nutrient_databank_number, :sequence_number, :amount,
          :measurement_description, :gram_weight, :num_data_points,
          :standard_deviation
        ]
      end

      def model
        UsdaNutrientDatabase::Weight
      end

      def log_import_started
        UsdaNutrientDatabase.log 'Importing weights'
      end
    end
  end
end
