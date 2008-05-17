require 'rubygems'
require 'activerecord'
require File.dirname(__FILE__) + '/../lib/active_record_each.rb'
require 'test/unit'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Migration.create_table :users do |t| ; t.string :name ; end

class User < ActiveRecord::Base
end

class ActiveRecordEachTest < Test::Unit::TestCase
  def setup
    User.delete_all
    User.create( :name => "Guillermo")
    User.create( :name => "Esther")
  end
  
  def test_each_method
    assert !User.respond_to?(:other_strange_method_that_dont_exists)
    assert User.respond_to?(:each)

  end
  
  def test_map_method
    assert User.respond_to?(:map)
    assert User.respond_to?(:collect)
    assert_equal User.map() {|u| u.name }.sort, ["Guillermo","Esther"].sort
  end

  def test_map_method_with_conditions
    assert_equal User.collect(:conditions => "users.name LIKE 'G%'") {|u| u.name}, ["Guillermo"]
  end
end
