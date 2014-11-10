require 'model_tokenizer'

DB.create_table :turtles do
  primary_key :id
  column :data, :string
  column :token, :string
end

class SomeModel < Sequel::Model(:turtles)
  include Tokenizable
end

class TokenGenerator < Test::Unit::TestCase
  def setup
    Turtle.all.each(&:destroy)
  end

  def test_should_create_token
    @turtle = Turtle.new :data => 'some data to insert'
    assert @turtle.save
    assert_not_nil @turtle.token
  end

  def method_name
    
  end
end
