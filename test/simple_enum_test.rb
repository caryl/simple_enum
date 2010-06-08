require File.dirname(__FILE__) + '/test_helper'

class SimpleEnumTest < Test::Unit::TestCase
  def setup
    @mock = Mock.new
    @mock.status = 2
  end
  
  def test_enum_scope
    assert_equal Mock.status_in(:normal).class, ActiveRecord::NamedScope::Scope
  end
  
  def test_enum_enums
    assert_equal Mock.status_enums, [[:normal, 1, '正常'],[:locked, 2, '锁定'],[:deleted, 3, '已删除'] ]
  end
  
  def test_options_for_enum
    assert_equal Mock.options_for_status, [['正常',1],['锁定',2],['已删除',3] ]
  end

  def test_enum_value
    assert_equal Mock.status_value(:locked), 2
    assert_equal Mock.status_value('正常'), 1
    assert_equal Mock.status_value(['正常', :deleted]), [1,3]
    assert_equal Mock.status_value(:other), nil
  end
  
  def test_enum_name
    assert_equal Mock.status_name(:locked), '锁定'
    assert_equal Mock.status_name('正常'), '正常'
    assert_equal Mock.status_name(1), '正常'
    assert_equal Mock.status_name(:other), nil
  end
  
  def test_enum_name
    assert @mock.status_is?(:locked)
    @mock.status = 1
    assert @mock.status_is?(:normal)
  end
  
  def test_enum_is?
    @mock.set_status_value(:locked)
    assert @mock.status_is?(:locked)
    assert @mock.status_is?(2)
    assert @mock.status_is?('锁定')
    assert !@mock.status_is?('其他')
  end
  
  def test_set_enum_value
    @mock.set_status_value(:normal)
    assert @mock.status_is?(:normal)
  end
  
  def test_set_default_value
    mock = Mock.new
    mock.set_default_enum_status
    assert mock.status_is?(:locked)
  end
end


class Mock < ActiveRecord::Base
  attr_accessor :status
  include SimpleEnum
  has_enum :status, :enums => [[:normal, 1, '正常'],[:locked, 2, '锁定'],[:deleted, 3, '已删除']], :column => :status, :default => :locked
end
