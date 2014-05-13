module UsdaNutrientDatabase
  module Import
    class FoodsNutrients
      FileImporter.register_file(self)

      def filename
        'NUT_DATA.txt'
      end

      def column_names
        [
          :nutrient_databank_number, :nutrient_number, :nutrient_value,
          :num_data_points, :standard_error, :src_code, :derivation_code,
          :ref_nutrient_databank_number, :add_nutrient_mark, :num_studies,
          :min, :max, :degrees_of_freedom, :lower_error_bound,
          :upper_error_bound, :statistical_comments, :add_mod_date,
          :confidence_code
        ]
      end

      def model
        UsdaNutrientDatabase::FoodsNutrient
      end

      def log_import_started
        UsdaNutrientDatabase.log 'Importing foods_nutrients'
      end

      def serialize_add_nutrient_mark(value)
        BooleanSerializer.serialize(value)
      end
    end
  end
end
