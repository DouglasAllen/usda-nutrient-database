require 'spec_helper'

module UsdaNutrientDatabase
  describe Import::ArchiveImporter do
    let(:importer) { described_class.new('tmp/usda', version: 'sr25') }

    before do
      importer.clean
    end

    describe '#import_archive' do
      before do
        stub_request(:get, /.*/).
          to_return(body: File.read('spec/support/sr25.zip'))
        importer.import_archive
      end

      it { expect(FoodGroup.count).to eql(25) }
      it { expect(Food.count).to eql(16) }
      it { expect(Nutrient.count).to eql(15) }
      it { expect(FoodsNutrient.count).to eql(12) }
      it { expect(Weight.count).to eql(11) }
      it { expect(Footnote.count).to eql(9) }

      context 'importing twice' do
        before { importer.import_archive }

        it { expect(FoodGroup.count).to eql(25) }
        it { expect(Food.count).to eql(16) }
        it { expect(Nutrient.count).to eql(15) }
        it { expect(FoodsNutrient.count).to eql(12) }
        it { expect(Weight.count).to eql(11) }
        it { expect(Footnote.count).to eql(9) }
      end
    end
  end
end
