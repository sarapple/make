module Builder
	def self.header(title)
		return '<meta charset="utf-8"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>'+title+'</title><meta name="description" content=""><meta name="viewport" content="width=device-width, initial-scale=1">'
	end
	def self.form(model, columnNames, options = {})
		# Convert given model into String
		controller=model.to_s.downcase+"s"
		# Set form action and method to create using REST conventions
		form = '<form action="/' + controller + '" method="post">'
		# if default optional parameters are passed in, make hidden inputs
		if options[:default]
			options[:default].each_pair do |key, value|
				form = form + '<input type="hidden" name="'+key.to_s+'" value="'+value.to_s+'">'
				# remove the created inputs from the columns Array (columnNames).
				columnNames.delete(key.to_s)
			end
		end
		# These are some typical form keys to ignore when rendering form
		toRemove = ['id', 'created_at', 'updated_at', 'salt', 'encrypted_password']
		toRemove.each do |item|
			columnNames.delete(item)
		end
		# Create text input labels for simple form creation
		columnNames.each do |column|
			form = form + '<label>' + column.titleize + '</label><input type="text" name="'+column+'">'
		end
		# Add authentication to each form requested
		form += '<input id="authenticity_token" name="authenticity_token" type="hidden" value="<%= form_authenticity_token %>"><input type="submit" value="Submit"></form>'
		return form
	end
end