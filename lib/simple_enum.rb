module SimpleEnum
  def self.included(base)
    base.extend EnumMethods
  end

  module EnumMethods
    def has_enum(name, options)
      column_attr = "enum_#{name}_column"
      enums_attr = "#{name}_enums"
      default_attr = "default_#{name}_enum"
      cattr_accessor column_attr, enums_attr, default_attr
      self.send("#{column_attr}=",  options[:column] || "#{name}_id")
      self.send("#{enums_attr}=", options[:enums])
      self.send("#{default_attr}=", options[:default] || options[:enums].first.first)
      self.module_eval do 
        named_scope "#{name}_in", lambda{|s|{:conditions=>{self.send(column_attr).to_sym => self.send("#{name}_value", s)}}}
        
        #类方法
        #enum_in的别名：enum_is
        self.class.send(:define_method, "#{name}_is") do |s|
          self.send "#{name}_in", s
        end

        #返回一个select options数组
        self.class.send(:define_method, "options_for_#{name}") do 
          self.send(enums_attr).map{|s|[s.last, s.second]}
        end

        #根据数组、符号、字符串返回value
        self.class.send(:define_method, "#{name}_value") do |param|
          if param.is_a?(Array)
            param.map{|p|self.send("#{name}_value",p)}
        elsif param.is_a?(Symbol)
            self.send(enums_attr).assoc(param).try(:second)
          elsif param.is_a?(String)
            self.send(enums_attr).detect{|s| s.third == param }.try(:second)
          else
            param
          end
        end

        #根据符号、字符串返回名称
        self.class.send(:define_method, "#{name}_name") do |param|
          self.send(enums_attr)
          if param.is_a?(Symbol)
            self.send(enums_attr).detect{|s| s.first == param }.try(:last)
          elsif param.is_a?(String)
            param
          else
            self.send(enums_attr).detect{|s| s.second == param }.try(:last)
          end
        end
        
        #当前名称
        self.send(:define_method, "#{name}_name") do
          self.class.send(enums_attr).detect {|s| s.second == self.send(self.send(column_attr))}.try(:last)
        end
        
        #当前key
        self.send(:define_method, "#{name}_key") do
          self.class.send(enums_attr).detect {|s| s.second == self.send(self.send(column_attr))}.try(:first)
        end
        
        #设置值
        self.send(:define_method, "set_#{name}_value") do |param|
          value_id =
            if param.is_a?(Symbol)  #key
            self.class.send("#{name}_value", param)
          elsif param.is_a?(String) #name
            self.send(enums_attr).detect {|s| s.last == param  }.try(:second)
          else #id
            param
          end
          self.send("#{self.send(column_attr)}=", value_id)
          value_id
        end

        #更新值
        self.send(:define_method, "update_#{name}_value") do |param|
          self.send("set_#{name}_value", param)
          self.save(false)
        end

        #判断当前实例是否是
        self.send(:define_method, "#{name}_is?") do |key|
          if key.is_a?(Array)
            key.detect{|p|self.send("#{name}_is?", p)}
          else
            self.class.send("#{name}_value", key) == self.send(self.send(column_attr))
          end
        end

        #默认值
        self.send(:define_method, "set_#{name}_default_value") do
          self.send("#{self.send(column_attr)}=", self.send("#{name}_default_value"))
        end
        
        self.send(:define_method, "#{name}_default_value") do
          self.class.send("#{name}_value", self.send(default_attr))
        end
        
        self.send(:define_method, "initialize_with_default_#{name}") do |*args|
          attrs = args.first
          self.send("initialize_without_default_#{name}", attrs)
          self.send("set_#{name}_default_value") unless attrs && attrs.include?(name)
        end
        
        alias_method_chain :initialize, "default_#{name}"
        #可使用name和column访问        
        alias_attribute name, self.send(column_attr) unless name.to_s == self.send(column_attr).to_s
      end
    end
  end
end
