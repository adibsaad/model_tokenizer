require 'rails/generators/active_record'
require 'rails/generators/migration'

module ModelTokenizer
  module Generators
    class ModelTokenizerGenerator <  ActiveRecord::Generators::Base
      include Rails::Generators::Migration

      argument :attributes, type: :array, default: [], banner: "field:type field:type"
      namespace "model_tokenizer"
      source_root File.expand_path("../templates", __FILE__)
      desc "Creates a model with the NAME argument. "\
           "If the model already exists, the appropriate code will be appended instead. "\
           "In either case, the appropriate migration will be created."

      def create_migration_file
        if (behavior == :invoke && model_exists?) || (behavior == :revoke && migration_exists?(table_name))
          migration_template "migration_existing.rb", "db/migrate/add_model_tokenizer_token_to_#{table_name}.rb"
        else
          migration_template "migration.rb", "db/migrate/model_tokenizer_create_#{table_name}.rb"
        end
      end

      def generate_model
        invoke "active_record:model", [name], migration: false unless model_exists? && behavior == :invoke
      end

      def inject_model_tokenizer_content
        content = model_contents

        class_path = if namespaced?
          class_name.to_s.split("::")
        else
          [class_name]
        end

        indent_depth = class_path.size - 1
        content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"

        inject_into_class(model_path, class_path.last, content) if model_exists?
      end

      private

      def migration_data
<<RUBY
      t.string :token, :null => false, :default => ""
RUBY
      end

      def model_contents
        <<-CONTENT
  extend ModelTokenizer
  has_token #:length => 14
  self.primary_key = :token
CONTENT
      end

      def model_exists?
        File.exists?(File.join(destination_root, model_path))
      end

      def migration_path
        @migration_path ||= File.join("db", "migrate")
      end

      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end

      def migration_exists?(table_name)
        Dir.glob("#{File.join(destination_root, migration_path)}/[0-9]*_*.rb").grep(/\d+_add_model_tokenizer_token_to_#{table_name}.rb$/).first
      end
    end
  end
end
