require 'make/builder'

module Make
	def self.header(title = 'title here')
		string = Builder.header(title)
		string = string.html_safe
		return string
	end
	def self.form(input)
		string = Builder.form(input.to_s, input.column_names)
		string = string.html_safe
		return string
	end
end