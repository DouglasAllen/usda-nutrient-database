module UsdaNutrientDatabase
  module Import
    class Footnotes
      FileImporter.register_file(self)

      def filename
        'FOOTNOTE.txt'
      end

      def column_names
        [
          :nutrient_databank_number, :footnote_number, :footnote_type,
          :nutrient_number, :footnote_text
        ]
      end

      def model
        UsdaNutrientDatabase::Footnote
      end

      def log_import_started
        UsdaNutrientDatabase.log 'Importing footnotes'
      end
    end
  end
end
