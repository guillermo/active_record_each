# ActiveRecordEach

class ActiveRecord::Base
  class << self
    # Each goes througt all entries in a model, without loading all
    # You can pass to it any parameter like find. See find for options you can pass
    #
    # ==== Examples:
    #
    #   # Goes throught all users wich name starts by g
    #   User.each (:conditions => "users.name LIKE 'g%'") do |u|
    #     puts u.name
    #   end
    #
    def each (*args)
      return 
      options = args.extract_options!
      validate_find_options(options)
      set_readonly_option!(options)
      
      count(options).times do |i|
        yield(find_initial(options.merge({:offset => i})))
      end
    end

    # Invokes block once for each element of self. Creates a new array containing the values returned by the block
    #
    # ==== Example:
    #
    #   #Get password from md5hash
    #   clean_password = User.map { |u| magic_recover_password(u.md5) }
    #
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

    # Collect is an alias for map
    alias_method :collect, :map

  end
end
