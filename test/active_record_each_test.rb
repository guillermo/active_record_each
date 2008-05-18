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
    User.create( :name => "Anders")
    User.create( :name => "Boomer")
    User.create( :name => "Esther")
    User.create( :name => "Guillermo")
    User.create( :name => "Kara")
  end
  
  def test_each_method
    assert !User.respond_to?(:other_strange_method_that_dont_exists)
    assert User.respond_to?(:each)
  end
  
  def test_map_method
    assert User.respond_to?(:map)
    assert User.respond_to?(:collect)
    assert_equal ["Anders","Boomer","Kara","Guillermo","Esther"].sort, User.map {|u| u.name }.sort
  end

  def test_each_with_conditions
    i=0
    User.each(:conditions => "users.name LIKE 'G%'") {|u| i+=1 }
    assert_equal 1, i
  end

  def test_fast_each_with_conditions
    i=0
    User.fast_each(:conditions => "users.name LIKE 'G%'") {|u| i+=1 }
    assert_equal 1, i
  end

  def test_fast_each_without_conditions
    i=0
    User.fast_each {|u| i+=1 }
    assert_equal 5, i
  end

  def test_each_without_conditions
    i=0
    User.each {|u| i+=1 }
    assert_equal 5, i
  end

  # TODO any easy way to handle reverse ordering of the primary key?
  def test_backwards_primary_key_map
    assert_equal ["Kara","Guillermo","Ester","Boomer","Anders"], User.map(:order => "id desc") { |u| u.name }
    assert_equal ["Kara","Guillermo","Ester","Boomer","Anders"], User.map(:order => "users.id desc") { |u| u.name }
  end

  def test_map_method_with_conditions
    assert_equal ["Guillermo"], User.map(:conditions => "users.name LIKE 'G%'") {|u| u.name}
  end
end
