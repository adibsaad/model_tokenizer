module ModelTokenizer
  module Test
    class Schema < ActiveRecord::Migration
      class << self
        def down
          drop_table :cars
        end

        def up
          # TODO: use schema version to avoid ugly hacks like this
          return if @done

          create_table :cars do |t|
            t.string :data
            t.string :token
          end

          create_table :trucks do |t|
            t.string :data
            t.string :token
          end
          
          @done = true
        end
      end
    end
  end
end
