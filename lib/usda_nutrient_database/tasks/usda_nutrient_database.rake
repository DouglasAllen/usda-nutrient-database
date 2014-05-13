namespace :usda do
  desc 'Import the latest USDA nutrition data'
  task import: :environment do
    directory = Rails.root.join('tmp/usda')
    importer = UsdaNutrientDatabase::Import::ArchiveImporter.new(directory)
    importer.import_archive
  end

  UsdaNutrientDatabase::Import::FileImporter.file_classes.each do |file_class|
    file_class_table_name = file_class.name.to_s.demodulize.underscore

    desc "Import the USDA #{file_class_table_name} table"
    task "import_#{file_class_table_name}" => :environment do
      directory = Rails.root.join('tmp/usda')
      importer = UsdaNutrientDatabase::Import::ArchiveImporter.new(directory)
      importer.import_file(file_class)
    end
  end
end
