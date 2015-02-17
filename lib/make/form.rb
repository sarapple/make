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
		if assoc		#if association is checked true
			array.each do |id|
				val = column[0...-3].capitalize.constantize.find(id).attributes.values[1]
				input += "\n\t\t\t<option value=\"" + id.to_s + "\">" + val.to_s + "</option>"
			end
		else			#if no associations exist for array
			array.each do |item| 
				input += "\n\t\t\t<option value=\"" + item.to_s + "\">" + item.to_s + "</option>"
			end
		end
		@potential_keys_to_ignore.push(column)
		input += "\n\t</select>"
		@formMiddle.push(input)
		return self
	end
	# Similar to select, but association assumed and specific associated column name can be selected
	def assoc column, assocColumn, array='all'
		columnName = column.titleize
		input = "\n\t<label>" + columnName + "\n\t</label>\n\t<select name=\"" + @modelName + "[" + column + "]\">"
		assocModel = column[0...-3].capitalize.constantize
		array = assocModel.distinct.count('id')
		assocModel.attributes.each_with_index do |attribute, index|
			if attribute.key == assocColumn
				assocIndex = index
			end
		end
		while array > 0
			val = assocModel.find(id).attributes.values[assocIndex]
			input += "\n\t\t\t<option value=\"" + id.to_s + "\">" + val.to_s + "</option>"
			array --
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