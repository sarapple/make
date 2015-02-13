Gem::Specification.new do |s|
	s.name = 'make'
	s.version = '0.2.6'
	s.executables << 'make'
	s.date = '2014-02-09'
	s.summary = 'Replace long strings of html with simple functions that create your forms and tables straight from your database.'
	s.description = 'A gem that shortcuts typing out forms and tables for SQL users. Assuming your model is named ModelName, just type Make.form.model(ModelName).now! in your controller and it will return an html-safe string from your column names for creating a new record. In addition, you can type Make.table.model("ModelName").now! to automatically generate a table. Use Make.header("Title") to make a default header.'
	s.authors = ['Sara Wong', 'Ulysses Lin']
	s.email = ['swong2@wellesley.edu', 'utemoc@gmail.com']
	s.files = ["lib/make.rb", "lib/make/header.rb", "lib/make/form.rb", "lib/make/table.rb"]
	s.homepage = 
		'http://rubygems.org/gems/make'
	s.licenses = ['Sara Wong', 'Ulysses Lin']
end
