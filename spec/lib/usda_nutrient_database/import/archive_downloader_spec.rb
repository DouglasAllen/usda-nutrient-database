require 'spec_helper'

module UsdaNutrientDatabase::Import
  describe ArchiveDownloader do
    let(:directory) { 'tmp/usda' }
    let(:version) { 'sr25' }
    let(:archive_importer) { ArchiveImporter.new(directory, version: version) }
    let(:downloader) { described_class.new(archive_importer) }
    let(:extraction_path) { "#{directory}/#{version}" }
    let(:filenames) do
      [
        'DATA_SRC.txt', 'DATSRCLN.txt', 'DERIV_CD.txt', 'FD_GROUP.txt',
        'FOOD_DES.txt', 'FOOTNOTE.txt', 'LANGDESC.txt', 'LANGUAL.txt',
        'NUTR_DEF.txt', 'NUT_DATA.txt', 'SRC_CD.txt', 'WEIGHT.txt',
        'sr25_doc.pdf'
      ]
    end

    before do
      archive_importer.clean
    end

    describe '#perform' do
      before do
        stub_request(:get, /.*/).
          to_return(body: File.read('spec/support/sr25.zip'))

        downloader.perform
      end

      it 'should download and extract all files' do
        filenames.each do |filename|
          expect(File.exist?("#{extraction_path}/#{filename}")).to eql(true)
        end
      end
    end
  end
end
