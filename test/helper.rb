require "bundler/setup"
require 'coveralls'
Coveralls.wear!

require "active_record"

#Put all your 'at_exit's that you want executed after
#running your tests BEFORE requiring minitest,
#as minitest uses at_exit to run the tests.
#Putting the follow line after requiring minitest will
#close the database connection before the first test runs.
at_exit {ActiveRecord::Base.connection.disconnect!}

require "minitest/autorun"

Minitest::Test = MiniTest::Unit::TestCase unless defined?(Minitest::Test)

#require "mocha/setup"

# if ENV["COVERAGE"]
#   require 'simplecov'
#   SimpleCov.start do
#     add_filter "test/"
#     add_filter "friendly_id/migration"
#   end
# end

# I18n.enforce_available_locales = false

require 'model_tokenizer'

# If you want to see the ActiveRecord log, invoke the tests using `rake test LOG=true`
# if ENV["LOG"]
#   require "logger"
#   ActiveRecord::Base.logger = Logger.new($stdout)
# end

module ModelTokenizer
  module Test
    def self.included(base)
      MiniTest::Unit.autorun
    end

    def transaction
      ActiveRecord::Base.transaction { yield ; raise ActiveRecord::Rollback }
    end

    def with_instance_of(*args)
      model_class = args.shift
      args[0] ||= {:data => "some data goes here"}
      transaction { yield model_class.create!(*args) }
    end

    module Database
      extend self

      def connect
        version = ActiveRecord::VERSION::STRING
        driver  = ModelTokenizer::Test::Database.driver
        engine  = RUBY_ENGINE rescue "ruby"

        ActiveRecord::Base.establish_connection config[driver]

        message = "Using #{engine} #{RUBY_VERSION} AR #{version} with #{driver}"

        puts "-" * 72
        if in_memory?
          ActiveRecord::Migration.verbose = false
          Schema.migrate :up
          puts "#{message} (in-memory)"
        else
          puts message
        end

      end

      def config
        @config ||= YAML::load(File.open(File.expand_path("../databases.yml", __FILE__)))
      end

      def driver
        (ENV["DB"] or "sqlite3").downcase
      end

      def in_memory?
        config[driver]["database"] == ":memory:"
      end
    end
  end
end

class Module
  def test(name, &block)
    define_method("test_#{name.gsub(/[^a-z0-9']/i, "_")}".to_sym, &block)
  end
end

require "schema"
ModelTokenizer::Test::Database.connect
