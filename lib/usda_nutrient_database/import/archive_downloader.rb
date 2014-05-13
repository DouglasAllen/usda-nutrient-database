require 'uri'
require 'fileutils'
require 'forwardable'
require 'zip'

module UsdaNutrientDatabase
  module Import
    class ArchiveDownloader
      extend Forwardable

      def_delegators :archive_importer, :base_directory, :version,
        :working_directory

      def initialize(archive_importer)
        @archive_importer = archive_importer
      end

      def perform
        download
        extract
      end

      def url
        "http://www.ars.usda.gov/SP2UserFiles/Place/12354500/Data/#{version.upcase}/dnload/#{version}.zip"
      end

      def filename
        "#{base_directory}/#{version}.zip"
      end

      def download
        UsdaNutrientDatabase.log "Downloading USDA data version: #{version}"

        uri = URI.parse(url)

        unless File.exist?(filename)
          FileUtils.mkdir_p(File.dirname(filename))

          Net::HTTP.start(uri.host) do |http|
            response = http.get(uri.path)
            File.open(filename, 'wb') do |file|
              file.write(response.body)
            end
          end
        end
      end

      def extract
        UsdaNutrientDatabase.log 'Extracting data'

        unless File.exist?(working_directory)
          FileUtils.mkdir_p(working_directory)

          Zip::File.open(filename) do |zipfile|
            zipfile.each do |file|
              fullpath = "#{working_directory}/#{file.name}"
              zipfile.extract(file, fullpath)
            end
          end
        end
      end

      private

      attr_reader :archive_importer
    end
  end
end
