require 'csv'
require 'forwardable'

module UsdaNutrientDatabase
  module Import
    class FileImporter
      def self.register_file(file_class)
        file_classes << file_class
      end

      def self.file_classes
        @_file_classes ||= []
      end

      def self.import(archive_importer, file_class)
        new(archive_importer, file_class.new).import
      end

      COLUMN_SEPARATOR = '^'
      QUOTE_CHARACTER = '~'

      extend Forwardable

      def_delegators :archive_importer, :working_directory
      def_delegators :file, :log_import_started, :model, :filename

      def initialize(archive_importer, file)
        @archive_importer = archive_importer
        @file = file
        full_path = File.join(working_directory, filename)
        @io = CSV.open(full_path, 'r:iso-8859-1:utf-8',
          col_sep: COLUMN_SEPARATOR,
          quote_char: QUOTE_CHARACTER
        )
        @column_names = file.column_names
        @connection = model.connection
        @raw_connection = connection.raw_connection
        @column_serializers = build_column_serializers
      end

      def import
        log_import_started
        model.delete_all
        copy_data
      end

      # Copied from postgres-copy: <https://github.com/diogob/postgres-copy>
      def copy_data
        connection.execute(query)

        while column_values = io.gets
          unless column_values.empty?
            line = serialize_column_values(column_values) + "\n"
            raw_connection.put_copy_data(line)
          end
        end

        raw_connection.put_copy_end
      end

      private

      attr_reader :archive_importer, :file, :io, :column_names, :connection, :raw_connection

      def build_column_serializers
        column_names.inject({}) do |hash, name|
          if file.respond_to?("serialize_#{name}")
            hash[name] = lambda do |value|
              file.public_send("serialize_#{name}", value)
            end
          else
            hash[name] = lambda do |value|
              if value
                QUOTE_CHARACTER + value + QUOTE_CHARACTER
              else
                ''
              end
            end
          end

          hash
        end
      end

      def query
        %<
          COPY #{table_name}
          (#{column_names_as_string})
          FROM STDIN
          DELIMITER '#{COLUMN_SEPARATOR}'
          CSV
          QUOTE '#{QUOTE_CHARACTER}'
        >
      end

      def column_names_as_string
        column_names.map { |name| %("#{name}") }.join(',')
      end

      def table_name
        model.quoted_table_name
      end

      def serialize_column_values(column_values)
        line = ""
        len = column_values.length
        i = 0

        while i < len
          value = column_values[i]
          name = @column_names[i]
          line << serialize_column_value(value, name).to_s + COLUMN_SEPARATOR
          i += 1
        end

        line.chop
      end

      def serialize_column_value(value, name)
        @column_serializers[name].call(value)
      end
    end
  end
end
