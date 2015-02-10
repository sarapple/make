class Form
	def initialize
		# Convert given model into String
		@formClass='make-form'
		# By default, set form action and method to create using REST conventions
		@formMethod='post'
		@formStart=''
		@formMiddle=[]
		@formEnd='<input id="authenticity_token" name="authenticity_token" type="hidden" value="<%= form_authenticity_token %>"><input type="submit" value="Submit"></form>'
		@default_keys_to_ignore = ['id', 'created_at', 'updated_at']
		@potential_keys_to_ignore = ['salt']
		@defaults = {}
		@keys_to_show=[]
		@selections = []
		@password_confirmation = true
		@model = {}
		@columns = []
	end
	def default column, value
		@defaults = @defaults.merge({column => value})
 		# remove the created inputs from the columns Array (columnNames).
 		@potential_keys_to_ignore.push(column.to_s)
	 	return self
	end
	def confirm change
		@password_confirmation = false
		return self
	end
	def model model
		@formAction = '/' + model.downcase+"s"
		@model = model.constantize
		return self
	end
	def select column, array, assoc = false
		columnName = column.titleize
		input = '<label>' + columnName + '</label><select name="' + column + '" value="' + column + '">'
		if assoc		#if association is checked true
			array.each do |id|
				val = column[0...-3].capitalize.constantize.find(id).attributes.values[1]
				input += '<option value="' + id.to_s + '">' + val.to_s + '</option>'
			end
		else			#if no associations exist for array
			array.each do |item| 
				input += '<option value="' + item.to_s + '">' + item.to_s + '</option>'
			end
		end
		@potential_keys_to_ignore.push(column)
		input += '</select>'
		@formMiddle.push(input)
		return self
	end
	# Build code from class variables
	def starter
		@formStart = '<form class="' + @formClass + '" action="' + @formAction + '" method="' + @formMethod + '">'
	end
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
				input = '<label>Password</label><input type="text" name="password">'
				@formMiddle.push(input)
				if @password_confirmation 
					input = '<label>Confirm Password</label><input type="text" name="password_confirmation">'
					@formMiddle.push(input)			
				end
			else
				input = '<label>' + column.titleize + '</label><input type="text" name="'+column+'">'
				@formMiddle.push(input)
			end
		end
		@defaults.each_pair do |key, value|
 			input = '<input type="hidden" name="'+key.to_s+'" value="'+value.to_s+'">'
 			puts input
 			puts @formMiddle
 			@formMiddle.push(input)
 		end
 	end
	def now!
		starter
		middle
		return (@formStart+@formMiddle.join+@formEnd).html_safe
	end
end