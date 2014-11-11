require 'rails/generators/active_record'
require 'generators/devise/orm_helpers'

module ActiveRecord
  module Generators
    class ModelTokenizerGenerator < ActiveRecord::Generators::Base
      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      source_root File.expand_path("../templates", __FILE__)

      def copy_model_tokenizer_migration
        if (behavior == :invoke && model_exists?) || (behavior == :revoke && migration_exists?(table_name))
          migration_template "migration_existing.rb", "db/migrate/add_model_tokenizer_token_to_#{table_name}.rb"
        else
          migration_template "migration.rb", "db/migrate/devise_create_#{table_name}.rb"
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

      def migration_data
<<RUBY
      t.string :token, :null => false, :default => ""
RUBY
      end

      def model_contents
        <<-CONTENT
  extend ModelTokenizer
  has_token
CONTENT
      end

      private

      def model_exists?
        File.exists?(File.join(destination_root, model_path))
      end

      def migration_exists?(table_name)
        Dir.glob("#{File.join(destination_root, migration_path)}/[0-9]*_*.rb").grep(/\d+_add_devise_to_#{table_name}.rb$/).first
      end

      def model_path
        @model_path ||= File.join("app", "models", "#{file_path}.rb")
      end
    end
  end
end
