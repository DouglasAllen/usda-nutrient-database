module UsdaNutrientDatabase
  module Import
    class Nutrients
      FileImporter.register_file(self)

      def filename
        'NUTR_DEF.txt'
      end

      def column_names
        [
          :nutrient_number, :units, :tagname, :nutrient_description,
          :number_decimal_places, :sort_record_order
        ]
      end

      def model
        UsdaNutrientDatabase::Nutrient
      end

      def log_import_started
        UsdaNutrientDatabase.log 'Importing nutrients'
      end
    end
  end
end
