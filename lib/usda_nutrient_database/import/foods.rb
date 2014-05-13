# encoding: utf-8

module UsdaNutrientDatabase
  module Import
    class Foods
      FileImporter.register_file(self)

      def filename
        'FOOD_DES.txt'
      end

      def column_names
        [
          :nutrient_databank_number, :food_group_code, :long_description,
          :short_description, :common_names, :manufacturer_name, :survey,
          :refuse_description, :percentage_refuse, :scientific_name,
          :nitrogen_factor, :protein_factor, :fat_factor, :carbohydrate_factor
        ]
      end

      def model
        UsdaNutrientDatabase::Food
      end

      def log_import_started
        UsdaNutrientDatabase.log 'Importing foods'
      end

      def serialize_survey(value)
        BooleanSerializer.serialize(value)
      end
    end
  end
end
