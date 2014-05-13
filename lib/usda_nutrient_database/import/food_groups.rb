module UsdaNutrientDatabase
  module Import
    class FoodGroups
      FileImporter.register_file(self)

      def filename
        'FD_GROUP.txt'
      end

      def column_names
        [:code, :description]
      end

      def model
        UsdaNutrientDatabase::FoodGroup
      end

      def log_import_started
        UsdaNutrientDatabase.log 'Importing food groups'
      end
    end
  end
end
