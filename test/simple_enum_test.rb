require File.dirname(__FILE__) + '/test_helper'

class SimpleEnumTest < Test::Unit::TestCase
  def setup
    @mock = Mock.new
  end
  
  def test_mock_new
    mock = Mock.new(:name => "my name", :status => '3')
    assert_equal mock.name, "my name"
    assert_equal mock.status, 3
    mock = Mock.new(:name => "my name")
    assert_equal mock.name, "my name"
    assert_equal mock.status, 2
  end
  
  def test_enum_scope
    assert_equal Mock.status_in(:normal).class, ActiveRecord::NamedScope::Scope
    assert_equal Mock.kind_in(:normal).class, ActiveRecord::NamedScope::Scope
    assert_equal Mock.status_is(:normal).class, ActiveRecord::NamedScope::Scope
  end
  
  def test_enum_enums
    assert_equal Mock.status_enums, [[:normal, 1, '正常'],[:locked, 2, '锁定'],[:deleted, 3, '已删除']]
    assert_equal Mock.kind_enums, [[:admin, 1, '管理员'],[:member, 2, '成员']]
  end
  
  def test_options_for_enum
    assert_equal Mock.options_for_status, [['正常',1],['锁定',2],['已删除',3]]
    assert_equal Mock.options_for_kind, [['管理员',1],['成员',2]]
  end

  def test_enum_value
    assert_equal Mock.status_value(:locked), 2
    assert_equal Mock.status_value('正常'), 1
    assert_equal Mock.status_value(['正常', :deleted]), [1,3]
    assert_equal Mock.status_value(:other), nil
    
    assert_equal Mock.kind_value(:admin), 1
    assert_equal Mock.kind_value('成员'), 2
    assert_equal Mock.kind_value(['成员', :admin]), [2,1]
    assert_equal Mock.kind_value(:other), nil
  end
  
  def test_class_enum_name
    assert_equal Mock.status_name(:locked), '锁定'
    assert_equal Mock.status_name('正常'), '正常'
    assert_equal Mock.status_name(1), '正常'
    assert_equal Mock.status_name(:other), nil
    
    assert_equal Mock.kind_name(:admin), '管理员'
    assert_equal Mock.kind_name('成员'), '成员'
    assert_equal Mock.kind_name(1), '管理员'
    assert_equal Mock.kind_name(:other), nil
  end
  
  def test_enum_default
    mock = Mock.new
    assert_equal mock.status, 2
    mock.status = 3
    assert_equal mock.status, 3
    assert_equal mock.status_default_value, 2
    
    mock = Mock.new
    assert_equal mock.kind, 1
    assert_equal mock.kind_id, 1
    mock.kind = 2
    assert_equal mock.kind, 2
    assert_equal mock.kind_id, 2
    assert_equal mock.kind_default_value, 1
  end

  def test_enum_key
    @mock.set_status_value(:locked)
    assert_equal @mock.status_key, :locked
    @mock.status = 1
    assert_equal @mock.status_key, :normal

    @mock.set_kind_value(:admin)
    assert_equal @mock.kind_key, :admin
    @mock.kind = 2
    assert_equal @mock.kind_key, :member
  end
  
  def test_enum_name
    @mock.set_status_value(:locked)
    assert_equal @mock.status_name, '锁定'
    @mock.status = 1
    assert_equal @mock.status_name, '正常'
    
    @mock.set_kind_value(:admin)
    assert_equal @mock.kind_name, '管理员'
    @mock.kind_id = 2
    assert_equal @mock.kind_name, '成员'
  end
  
  def test_enum_is?
    @mock.set_status_value(:locked)
    assert @mock.status_is?(:locked)
    assert @mock.status_is?(2)
    assert @mock.status_is?('锁定')
    assert !@mock.status_is?('其他')
    
    @mock.set_kind_value(:admin)
    assert @mock.kind_is?(:admin)
    assert @mock.kind_is?(1)
    assert @mock.kind_is?('管理员')
    assert !@mock.kind_is?(:member)
  end
  
  def test_set_enum_value
    @mock.set_status_value(:normal)
    assert @mock.status_is?(:normal)
  
    @mock.set_kind_value(:member)
    assert @mock.kind_is?(:member)
  end
  
  def test_update_enum_value
    @mock.update_status_value(:normal)
    @mock.reload
    assert @mock.status_is?(:normal)
  end
  
  def test_set_default_value
    mock = Mock.new
    mock.status = 1
    mock.set_status_default_value
    assert mock.status_is?(:locked)
    
    mock.kind_id = 2
    assert mock.kind_is?(:member)
    mock.set_kind_default_value
    assert mock.kind_is?(:admin)
  end
  
  def test_enum_on_save
    mock = Mock.new
    mock.save
    assert mock.status_is?(:locked)
    assert mock.kind_is?(:admin)
    
    mock.set_status_value(:normal)
    mock.set_kind_value(:member)
    mock.save
    assert mock.status_is?(:normal)
    assert mock.kind_is?(:member)
  end
end


class Mock < ActiveRecord::Base
  attr_accessor :kind_id
  include SimpleEnum
  has_enum :status, :enums => [[:normal, 1, '正常'],[:locked, 2, '锁定'],[:deleted, 3, '已删除']], :column => :status, :default => :locked
  has_enum :kind, :enums => [[:admin, 1, '管理员'],[:member, 2, '成员']], :column => :kind_id
end
