require 'spec_helper'

module UsdaNutrientDatabase::Import
  describe Foods do
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
      UsdaNutrientDatabase::Food
    end

    describe '#import' do
      before { file_importer.import }

      it { expect(model.count).to eql(4) }

      it { expect(model.where(food_group_code: '0100').count).to eql(3) }
    end
  end
end
