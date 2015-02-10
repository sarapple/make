require 'make/header.rb'
require 'make/form.rb'
require 'make/table.rb'

module Make
	def self.header(title = 'title here')
		string = Header.header(title)
		string = string.html_safe
		return string
	end
	def self.form
		Form.new
	end
	def self.table
		Table.new
	end
	def self.ctable
		Ctable.new
	end
end