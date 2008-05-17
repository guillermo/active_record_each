# ActiveRecordEach

class ActiveRecord::Base
  class << self
    def each (*args)
      options = args.extract_options!
      validate_find_options(options)
      set_readonly_option!(options)
      
      count(options).times do |i|
        yield(find_initial(options.merge({:offset => i})))
      end
    end

    def map(*args)
      options = args.extract_options!
      validate_find_options(options)
      set_readonly_option!(options)

      results = Array.new
      count(options).times do |i|
        results << yield(find_initial(options.merge({:offset => i})))
      end
      results
    end
    alias_method :collect, :map

  end
end
