module UsdaNutrientDatabase
  module Import
    class ArchiveImporter
      def initialize(base_directory, options = {})
        @base_directory = base_directory
        @version = options.fetch(:version, 'sr25')
        @downloader = ArchiveDownloader.new(self)
      end

      def import_archive
        with_archive_available do
          FileImporter.file_classes.each do |file_class|
            FileImporter.import(self, file_class)
          end
        end
      end

      def import_file(file_class)
        with_archive_available do
          FileImporter.import(self, file_class)
        end
      end

      def clean
        FileUtils.rm_rf(base_directory)
      end

      def working_directory
        "#{base_directory}/#{version}"
      end

      private

      attr_reader :base_directory, :version, :downloader, :file_importer

      def with_archive_available
        downloader.perform
        yield
      end
    end
  end
end
