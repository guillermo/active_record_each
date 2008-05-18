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
    @users = %w(Anders Boomer Esther Guillermo Kara)
    @users.each { |name| User.create( :name => name) }
    User.find_by_name("Anders").update_attribute(:id, 999999)
  end
  
  def test_each_method
    assert !User.respond_to?(:other_strange_method_that_dont_exists)
    assert User.respond_to?(:each)
  end
  
  def test_map_method
    assert User.respond_to?(:map)
    assert User.respond_to?(:collect)
    assert_equal @users, User.map {|u| u.name }.sort
  end

  def test_each_with_conditions
    i=0
    User.each(:conditions => "users.name LIKE 'G%'") {|u| i+=1 }
    assert_equal 1, i
  end

  def test_each_without_conditions
    i=0
    User.each {|u| i+=1 }
    assert_equal 5, i
  end

  # TODO any easy way to handle reverse ordering of the primary key?
  #   Not if absolutely necessary, that, anyway, they travelled to all records, and this could mess code. What do you think?
  def test_backwards_primary_key_map
    assert_equal @users, User.map(:order => "id desc") { |u| u.name }.sort
    assert_equal @users, User.map(:order => "users.id desc") { |u| u.name }.sort
  end

  def test_map_method_with_conditions
    assert_equal ["Guillermo"], User.map(:conditions => "users.name LIKE 'G%'") {|u| u.name}
  end

  def test_empty_result_set_dont_throw_exception
    assert_nothing_raised (ActiveRecord::RecordNotFound) do
      User.each(:conditions => "id = -1") { |u| u.name }
    end
  end
end
