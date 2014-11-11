require "helper"

class Car < ActiveRecord::Base
  extend ModelTokenizer
  has_token
end

class Truck < ActiveRecord::Base
  extend ModelTokenizer
  has_token :length => 16
end

class TokenGenerator < MiniTest::Test
  include ModelTokenizer::Test

  def setup
    Car.all.each(&:destroy)
    Truck.all.each(&:destroy)
  end

  def test_that_tokens_are_created_for_models
    with_instance_of(Car) do |record|
      assert record.token, "Token is nil"
      assert record.token.length == Car::model_tokenizer_token_length,
      "Token length is not #{Car::model_tokenizer_token_length}"
      
      record.token.split("").each do |c|
        assert ModelTokenizer::Base::CHARSET.include?(c), "#{c} doesn't belong in the acceptable character set"
      end
    end

    with_instance_of(Truck) do |record|
      assert record.token, "Token is nil"
      assert record.token.length == Truck::model_tokenizer_token_length,
      "Token length is not #{Truck::model_tokenizer_token_length}"
      
      record.token.split("").each do |c|
        assert ModelTokenizer::Base::CHARSET.include?(c), "#{c} doesn't belong in the acceptable character set"
      end
    end
  end
end
