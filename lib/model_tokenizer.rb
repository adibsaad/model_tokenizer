require "model_tokenizer/version"
require "model_tokenizer/base"

module ModelTokenizer
  def self.extended(base)
    return if base.respond_to? :model_tokenizer
    base.class_eval do
      extend Base
      before_create :generate_token
    end
  end

  def self.included(base)
    base.extend self
  end
end
