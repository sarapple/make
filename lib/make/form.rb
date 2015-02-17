class Form
	def initialize
		# Convert given model into String
		@formClass='make-form'
		# By default, set form action and method to create using REST conventions
		@formMethod='post'
		@formMethodHidden=nil
		@formStart=''
		@formMiddle=[]
		@formEnd="\n\t<input id=\"authenticity_token\" name=\"authenticity_token\" type=\"hidden\" value=\"<%= form_authenticity_token %>\">\n\t<input type=\"submit\" value=\"Submit\">\n</form>"
		@default_keys_to_ignore = ['id', 'created_at', 'updated_at']
		@potential_keys_to_ignore = ['salt']
		@defaults = {}
		@keys_to_show=[]
		@selections = []
		@password_confirmation = true
		@model = {}
		@modelName = ''
		@columns = []
		@id = nil
	end
	# First class method accessed in form, passing in form as a string
	def model model
		@modelName = model.downcase
		# Set default form's Action based on REST conventions /users
		@formAction = "/" + @modelName.downcase + "s"
		@model = model.constantize
		return self
	end
	# change action url if specific and does not follow REST
	def action url
		@formAction = url
		return self
	end
	# hide array of specific fields that should not be submitted through
	def hide columns
		columns.each do |col|
			@potential_keys_to_ignore.push(col.to_s)
		end
		return self
	end
	# Change form class
	def class myClass
		@formClass = myClass
		return self
	end
	# Determine default value for a specific field. Because no options exist, it will be hidden.
	def default column, value
		@defaults = @defaults.merge({column => value})
 		# remove the created inputs from the columns Array (columnNames).
 		@potential_keys_to_ignore.push(column.to_s)
	 	return self
	end
	# Default requires password confirmation, if none is needed change it will no longer require it.
	def no_pw_confirm
		@password_confirmation = false
		return self
	end
	# Change the form method to put, patch, or delete.
	def method type, id
		@formMethodHidden = type
		@id = id
		return self
	end
	# Similar to default, but instead of a hidden specific value you pass in an array and create a select/option field.
	def select column, array, assoc = false
		columnName = column.titleize
		input = "\n\t<label>" + columnName + "\n\t</label>\n\t<select name=\"" + @modelName + "[" + column + "]\">"
		input += "\n\t\t\t<option value=\"" + item.to_s + "\">" + item.to_s + "</option>"
		@potential_keys_to_ignore.push(column)
		input += "\n\t</select>"
		@formMiddle.push(input)
		return self
	end
	# Similar to select, but association assumed and specific associated column name can be selected
	def assoc column, assoc_column, assoc_model=nil
		# titleize column
		columnName = column.titleize
		# Create for input
		input = "\n\t<label>" + columnName + "\n\t</label>\n\t<select name=\"" + @modelName + "[" + column + "]\">"
		# Remove _id and take the assocModel unless assocModel exists
		if assoc_model
			assoc_model = assoc_model.capitalize.constantize
		else 
			assoc_model = column[0...-3].capitalize.constantize
		end
		# Keep track of how many records exist in assocModel
		total = assoc_model.distinct.count('id')
		# run a while loop for as many records there are
		counter = 1
		while counter <= total do
			val = assoc_model.find(counter).attributes[assoc_column]
			input += "\n\t\t\t<option value=\"" + counter.to_s + "\">" + val.to_s + "</option>"
			counter+= 1
		end
		input += "\n\t</select>"
		@potential_keys_to_ignore.push(column)
		@formMiddle.push(input)
		return self
	end
	# Build starting code from class variables called upon by now!
	def starter
		if @formMethodHidden
			@formStart = "<form class=\"" + @formClass + "\" action=\"" + @formAction + "/"+ @id.to_s + "\" method=\"" + @formMethod + "\">"
			@formStart += "\n\t<input name=\"_method\" type=\"hidden\" value=\"" + @formMethodHidden + "\">"				
		else
			@formStart = "<form class=\"" + @formClass + "\" action=\"" + @formAction + "\" method=\"" + @formMethod + "\">"			
		end
	end
	# Build remaining code from class variables called upon by now!
	def middle
		@columns = @keys_to_show + @model.column_names - @default_keys_to_ignore
		@potential_keys_to_ignore.each do |item|
			puts 'got in potential'
			@columns.delete(item)
			puts @columns
			puts @item
		end
		# Create text input labels
		@columns.each do |column|
			if column.include? 'password'
				input = "\n\t<label>Password</label>\n\t<input type=\"password\" name=\"" + @modelName + "[password]\">"
				@formMiddle.push(input)
				if @password_confirmation 
					input = "\n\t<label>Confirm Password</label>\n\t<input type=\"password\" name=\""  + @modelName + "[password_confirmation]\">"
					@formMiddle.push(input)			
				end
			elsif column.include? 'date'
				input = "\n\t<label>"+column.titleize+"</label>\n\t<input type=\"date\" name=\"" + @modelName + "[" + column + "]\">"
				@formMiddle.push(input)
			else
				input = "\n\t<label>" + column.titleize + "\n\t</label>\n\t<input type=\"text\" name=\"" + @modelName + "[" + column + "]\">"
				@formMiddle.push(input)
			end
		end
		@defaults.each_pair do |key, value|
 			input = "\n\t<input type=\"hidden\" name=\"" + @modelName + '[' + key.to_s + "]\" value=\"" + value.to_s + "\">"	
 			puts input
 			puts @formMiddle
 			@formMiddle.push(input)
 		end
 	end
 	# At the end of building the form, return the final string.
	def now!
		starter
		middle
		return (@formStart+@formMiddle.join+@formEnd).html_safe
	end
end