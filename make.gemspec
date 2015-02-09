Gem::Specification.new do |s|
	s.name = 'make'
	s.version = '2.0.0'
	s.executables << 'make'
	s.date = '2014-02-09'
	s.summary = 'Replace long strings of html with simple functions that create your forms and tables straight from your database.'
	s.description = 'A gem that shortcuts typing out forms for SQL users. Assuming your model is named DB_Name, just type <%= Make.form(DB_Name) %> wherever in your Rails view and it will return an html-safe string from your column names for creating a new record. In addition, you can type <%= Make.table(DB_Name.all) %> to automatically generate a table. More functions to follow!'
	s.authors = ['Sara Wong', 'Ulysses Lin']
	s.email = ['swong2@wellesley.edu', 'utemoc@gmail.com']
	s.files = ["lib/make.rb", "lib/make/header.rb", "lib/make/form.rb", "lib/make/table.rb"]
	s.homepage = 
		'http://rubygems.org/gems/make'
	s.licenses = ['Sara Wong', 'Ulysses Lin']
end
