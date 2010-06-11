ActiveRecord::Schema.define(:version => 0) do
	create_table :mocks, :force => true do |t|
		t.integer :status
	end
end
