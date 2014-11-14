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

Run

    $ rails g model_tokenizer MODEL_NAME [field:type field:type ... ]

to create a new tokenized model. If the model already exists, ModelTokenizer will integrate into it by injecting the following code

```ruby
  extend ModelTokenizer
  has_token
  self.primary_key = :token
```

The appropriate migration will also be created, which will create the ```token``` field and its associated unique index.

The default token length is 14, but you can change it (no lower than 8)

```ruby
  has_token :length => 16
```

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

However, the gem doesn't check for awkward tokens that could be confusing, has too many repeating characters, too many underscores/hyphens or otherwise makes someone raise an eyebrow (e.g. DXMHMHLALAH, _-aj-a2j6f-qacins-). Additionally, ModelTokenizer doesn't detect whether or not it has run out of combinations for 
generating new tokens, though this will be dealt with in the future.

ModelTokenizer has been tested with Rails 3 and 4.

## Contributing

1. Fork it ( https://github.com/adibsaad/model_tokenizer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
