require 'spec_helper'

module UsdaNutrientDatabase::Import
  describe FoodsNutrients do
    let(:archive_importer) do
      ArchiveImporter.new('spec/support', version: 'sr25')
    end

    let(:file) do
      described_class.new
    end

    let(:file_importer) do
      FileImporter.new(archive_importer, file)
    end

    def model
      UsdaNutrientDatabase::FoodsNutrient
    end

    describe '#import' do
      before { file_importer.import }

      it { expect(model.count).to eql(5) }
    end
  end
end
