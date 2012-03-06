ActiveRecord::Schema.define(:version => 0) do
	create_table :mocks, :force => true do |t|
	  t.string :name
		t.integer :status
	end
end
