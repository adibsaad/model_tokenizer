module ModelTokenizer
  module Models
    module Tokenizable
      extend ActiveSupport::Concern

      @@charset = %w{
        a b c d e f g h j k   m n o p q r s t u v w x y z
        A B C D E F G H J K L M N   P   R S T     W X Y Z
        1 2 3 4 5 6 7 8 9
        - _
      }

      included do
        before_create :generate_token
      end
      
      module ClassMethods
        
      end
      
      module InstanceMethods
        
      end

      protected

      def generate_token
        self.token = loop do
          random_token = (0...12).map{@@charset[rand(@@charset.size)]}.join
          break random_token unless self.class.exists?(:token => random_token)
        end
      end
    end
  end
end