require 'make/header.rb'
require 'make/form.rb'
require 'make/table.rb'

module Make
	def self.header(title = 'title here')
		string = Header.header(title)
		string = string.html_safe
		return string
	end
	def self.form(input, options = {})
		string = Form.form(input.to_s, input.column_names, options)
		string = string.html_safe
		return string
	end
	def self.table
		Table.new
	end
end