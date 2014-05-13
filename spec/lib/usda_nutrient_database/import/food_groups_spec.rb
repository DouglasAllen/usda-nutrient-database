require 'spec_helper'

module UsdaNutrientDatabase::Import
  describe FoodGroups do
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
      UsdaNutrientDatabase::FoodGroup
    end

    describe '#import' do
      before { file_importer.import }

      it 'should import all food groups' do
        expect(model.count).to eql(2)
      end

      it 'should import food group data correctly' do
        [
          { code: '0100', description: 'Dairy and Egg Products' },
          { code: '0200', description: 'Spices and Herbs' }
        ].each do |product|
          conditions = {
            code: product[:code],
            description: product[:description]
          }
          count = model.where(conditions).count
          expect(count).to eql(1)
        end
      end
    end
  end
end
