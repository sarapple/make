module Builder
	def self.header(title)
		return '<meta charset="utf-8"><meta http-equiv="X-UA-Compatible" content="IE=edge"><title>'+title+'</title><meta name="description" content=""><meta name="viewport" content="width=device-width, initial-scale=1">'
	end
	def self.form(db, columnNames)
		puts 'in builder form'
		form = '<form action="/' + db.to_s.downcase + 's" method="post">'
		columnNames.each do |column|
			if column == 'id' || column == 'created_at' || column == 'updated_at'
				puts column
			elsif column[-3..-1] == '_id'
				puts 'found an _id column'
			else
				form = form + '<label>' + column.titleize + '</label><input type="text" name="'+column+'">'
			end
		end
		form += '<input id="authenticity_token" name="authenticity_token" type="hidden" value="<%= form_authenticity_token %>"><input type="submit" value="Submit"></form>'
		return form
	end
end