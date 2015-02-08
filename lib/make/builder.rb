module Builder
	def self.header(title)
		return '<meta charset="utf-8"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>'+title+'</title><meta name="description" content=""><meta name="viewport" content="width=device-width, initial-scale=1">'
	end
	def self.form(db, columnNames, options = {})
		puts 'in builder form'
		form = '<form action="/' + db.to_s.downcase + 's" method="post">'
		if options[:default]
			options[:default].each_pair do |key, value|
				form = form + '<input type="hidden" name="'+key.to_s+'" value="'+value.to_s+'">'
				columnNames.delete(key.to_s)
			end
		end
		toRemove = ['id', 'created_at', 'updated_at', 'salt']
		toRemove.each do |item|
			columnNames.delete(item)
		end
		columnNames.each do |column|
			form = form + '<label>' + column.titleize + '</label><input type="text" name="'+column+'">'
		end
		# 	elsif column[-3..-1] == '_id'
		# 		# form = form + '<select name="column">'
		# 		# assocName = column[0..-4] + 's'
		# 		# puts assocName
		# 	else
		# 	end
		# end
		# if options[:default]
		# 	puts 'default exists'
		form += '<input id="authenticity_token" name="authenticity_token" type="hidden" value="<%= form_authenticity_token %>"><input type="submit" value="Submit"></form>'
		return form
	end
end