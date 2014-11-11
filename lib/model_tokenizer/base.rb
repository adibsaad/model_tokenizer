module ModelTokenizer
  module Base
    CHARSET = %w{
      a b c d e f g h   j k   m n o p q r s t u v w x y z
      A B C D E F G H   J K L M N   P   R S T     W X Y Z
      2 3 4 5 6 7 8 9
      - _
    }

    #Default length is 14 characters. Provides 
    #(1.0/55.0)**14 = 4,353,548,972,850 unique tokens.
    @@model_tokenizer_token_length = 14

    def model_tokenizer_token_length
      @@model_tokenizer_token_length
    end

    def has_token(*attributes)
      options = {
        :length => @@model_tokenizer_token_length
      }.merge!(attributes.last.is_a?(Hash) ? attributes.pop : {})

      if(!options[:length].is_a?(Integer) || options[:length] < 8)
        options[:length] = @@model_tokenizer_token_length
      end

      @@model_tokenizer_token_length = options[:length]

      include InstanceMethods
    end

    module InstanceMethods
      def to_param
        token
      end

      protected
      def generate_token
        self.token = loop do
          random_token = (0...self.class.model_tokenizer_token_length).map{CHARSET[rand(CHARSET.size)]}.join
          break random_token unless self.class.exists?(:token => random_token)
        end
      end
    end
  end
end
