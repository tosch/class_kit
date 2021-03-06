module ClassKit
  class Helper

    def initialize
      @hash_helper = HashKit::Helper.new
      @json_helper = JsonKit::Helper.new
      @attribute_helper = ClassKit::AttributeHelper.new
      @value_helper = ClassKit::ValueHelper.new
    end

    def is_class_kit?(klass)
      begin
        if !klass.class_variable_defined?(:@@is_class_kit_class)
          return false
        end
      rescue
        return false
      end

      return true
    end

    def validate_class_kit(klass)
      if !is_class_kit?(klass)
        raise ClassKit::Exceptions::InvalidClassError.new("Class: #{klass} does not implement ClassKit.")
      end
      return true
    end

    def to_hash(object)
      validate_class_kit(object.class)
      return @hash_helper.to_hash(object)
    end

    def from_hash(hash: hash, klass: klass)
      validate_class_kit(klass)
      hash = @hash_helper.symbolize(hash)
      entity = klass.new
      attributes = @attribute_helper.get_attributes(klass)
      attributes.each do |a|
        key = a[:name]
        type = a[:type]

        #if the hash value is nil skip it
        if hash[key] == nil
          next
        end

        if is_class_kit?(type)
          value = from_hash(hash: hash[key], klass: type)
        elsif type == Array
          value = hash[key].map do |i|
            if a[:collection_type] != nil
              if is_class_kit?(a[:collection_type])
                from_hash(hash: i, klass: a[:collection_type])
              else
                @value_helper.parse(type: a[:collection_type], value: i)
              end
            else
              i
            end
          end
        else
          value = hash[key]
        end
        eval("entity.#{key}=value")
      end
      return entity
    end

    def to_json(object)
      @json_helper.to_json(object)
    end

    def from_json(json: json, klass: klass)
      hash = JSON.load(json)
      return from_hash(hash: hash, klass: klass)
    end

  end
end