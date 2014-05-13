module UsdaNutrientDatabase
  module Import
    class SourceCodes
      FileImporter.register_file(self)

      def filename
        'SRC_CD.txt'
      end

      def column_names
        [:code, :description]
      end

      def model
        UsdaNutrientDatabase::SourceCode
      end

      def log_import_started
        UsdaNutrientDatabase.log 'Source code import started'
      end
    end
  end
end
