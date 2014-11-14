# ModelTokenizer

Generates random tokens that models can be accessed by. Instead of

```
somesite.com/video/71589
```

you'll get

```
somesite.com/video/j5-drkENpSDBNRds
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'model_tokenizer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install model_tokenizer

## Usage

1. Run

        $ rails g model_tokenizer MODEL_NAME [field:type field:type ... ]

  to create a new tokenized model. If the model already exists, ModelTokenizer will integrate into it by injecting the following code

  ```ruby
    extend ModelTokenizer
    has_token
  ```

  The appropriate migration will also be created, which will create the ```token``` field and its associated unique index.

  The default token length is 14, but you can change it (no lower than 8)

  ```ruby
    has_token :length => 16
  ```

2. In your ```routes.rb``` file, if you're using ```resource```/```resources``` to create routes for your model, make sure ```:token``` is used as the lookup param

  ```ruby
  resources :videos, :param => :token
  ```

  otherwise, change ```:id``` to ```:token``` where necessary.

3. In the model file, make sure the following line is there:

  ```ruby
  self.primary_key = :token
  ```

  The generator will automatically inject this, but if you're doing something weird that involves manually installing ModelTokenizer without using the generators, make sure the aforementioned line exists.


## Notes

ModelTokenizer generates tokens from the following charset:

```
a b c d e f g h i j k   m n o p q r s t u v w x y z
A B C D E F G H   J K L M N   P   R S T     W X Y Z
2 3 4 5 6 7 8 9
- _
```

As you may have noticed, the following ambiguous characters have been removed

* Lowercase: l
* Uppercase: I, O, Q, U, V
* Numerals:  1, 0

Currently, ModelTokenizer doesn't detect whether or not it has run out of combinations for 
generating new tokens, though this will be dealt with in the future.

## Contributing

1. Fork it ( https://github.com/adibsaad/model_tokenizer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
