# ClassKit

Welcome to your ClassKit! ClassKit is a toolkit for working with entities & classes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'class_kit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install class_kit

## Usage

###Creating an entity

    class Contact
        extend ClassKit   
             
        attr_accessor_type :landline, type: String
        attr_accessor_type :mobile, type: String
        attr_accessor_type :email, type: String
    end
        
    class Address
        extend ClassKit   
             
        attr_accessor_type :line1, type: String
        attr_accessor_type :line2
        attr_accessor_type :postcode
    end
    
    class Employee
        extend ClassKit
        
        attr_accessor_type :name, type: String
        attr_accessor_type :dob, type: Date
        attr_accessor_type :address, type: Address, auto_init: true
        attr_accessor_type :contacts, type: Array, collection_type: Contact, auto_init: true
    end
    
ClassKit entities can be created by implementing the `extend ClassKit` extend into the entity class and then using the `attr_accessor_type` method to register attributes as above inplace of the standard ruby `attr_accessor` method.

###attr_accessor_type

This method is used to add typed attributes to a class.

Supported standard types:

- String
- Integer
- Float
- BigDecimal
- Date
- DateTime
- Time
- :bool (true/false)
- Regexp

The above supported standard types will attempt to parse any values passed to the attribute if the value is not of the same type as the attribute. 

Example:

    entity.dob = '03-JUN-1980'
    
Would be parsed into a `Date` object and set to the attribute, so that subsequent calls to get the value from the attribute would return a `Date` object for the `entity.dob` value.

Attributes can have any type specified, they are not limited to the standard types listed above, however only the standard types listed above will attempt to parse non type matching values when setting the attribute value.

If an invalid value is passed to an attribute it will raise a `ClassKit::Exceptions::InvalidAttributeValueError` exception.

Attributes don't require the `type:` argument to be specified for attributes where type information is variable or not required.

####Arrays

The `attr_accessor_type` method allows attributes of type `Array` to be specified, these attributes can also specify the `collection_type:` argument to specify what the type the elements of the Array will be.

####Additional Arguments

The below are additional arguments that can be specified when using the `attr_accessor_type` method.

- `allow_nil:` This argument is used to specify if an attribute is allowed to have nil set as it's value.
- `auto_init:` This argument is used to specify an attribute should auto initialise it's value when nil. (Useful for Array's and Nested entities)
- `default:` This argument is used to specify a default value that the attribute should be set to when nil.
- `meta:` This argument is used to specify any additional meta information you want to attach to the attribute.

###ClassKit::Helper

This helper class provides several useful helper methods for working with ClassKit entities.

#### #is_class_kit?(object)

This method is called to determine if an object is a ClassKit entity or not.

[Params]
- `object` This is the object to check.

[Return]

`true` or `false`

#### #to_hash(object)

This method is called to convert a ClassKit entity into a `Hash`.

[Params]
- `object` This is the ClassKit entity to convert.

[Return]

`Hash`
        
#### #from_hash(hash:,klass:)

This method is called to convert a `Hash` into a ClassKit entity.

[Params]
- `hash:` This is the `Hash` to convert.
- `klass:` This is the class of the ClassKit entity you want to convert the `Hash` into.

[Return]

ClassKit entity.

#### #to_json(object)

This method is called to convert a ClassKit entity into JSON.

[Params]
- `object` This is the ClassKit entity to convert.

[Return]

JSON string.

#### #from_json(json:, klass:)

This method is called to convert a JSON string into a ClassKit entity.

[Params]
- `json:` This is the JSON string to convert.
- `klass:` This is the class of the ClassKit entity you want to convert the JSON into.

[Return]

ClassKit entity.

NOTE: This method will parse any nested Hashes that match attributes specified with a type: that is a ClassKit entity, as well as populating `Arrays` where the `collection_type:` has been specified as a ClassKit entity.

Example:

    {"name":"Joe Bloggs","dob":"03-JUNE-1980","address":{"line1":"25 The Street","line2":"Home Town","postcode":"NE3 5RT"},"contacts":[{"landline":"01235456789","mobile":"0789456123","email":"joe.bloggs@test.com"}]}
    
Would be parsed into the ClassKit `Employee` class defined above along with the nested `Address` attribute and `Contact` array.

Allowing the `Address` to be accessed via `entity.address.line1` etc and the `Contact` details to be accessed via `entity.contacts[0].landline` etc.


###ClassKit::AttributeHelper

This helper class provides several useful methods for accessing the attribute details for a ClassKit entity.

#### #get_attribute_type(klass:, name:)

This method is called to get the type of a specific attribute of a ClassKit entity.

[Params]
- `klass:` This is the ClassKit entity class that contains the attribute.
- `name:` This is the name of the attribute to get the type for.

[Return]

`Type`

#### #get_attribute(klass:, name:)

This method is called to get the details of a specific attribute of a ClassKit entity.

[Params]
- `klass:` This is the ClassKit entity class that contains the attribute.
- `name:` This is the name of the attribute to get the details for.

[Return]

`Hash` of `{ name:, type:, collection_type:, allow_nil:, default:, auto_init:, meta: }`

#### #get_attributes(klass)

This method is called to get an array of the Attribute details for a specified ClassKit entity.

[Params]
- `klass` This is the ClassKit entity class to get the attribute details for.

[Return]

`Array` of `{ name:, type:, collection_type:, allow_nil:, default:, auto_init:, meta: }`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vaughanbrittonsage/class_kit. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

