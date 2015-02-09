class Table
	def initialize
		@thead=''
		@tbody=''
		# These are the table keys to ignore when rendering table
		@keys_to_ignore=['id','created_at','updated_at']
		@keys_to_show=[]
		@combination=[]
	end

	# Assigns desired column names to be combined
	def combo cols
		cols.each { |result,parts|
			@combination=parts
			@keys_to_ignore+=parts
			@keys_to_show.push(result)
		}
		return self
	end

	# Assigns previously hidden column names as to be shown
	def show *to_show
		@keys_to_ignore-=to_show
		return self
	end

	# Must provide model as a String, uppercase
	def model model,*rest
		controller=model.downcase+"s"
		# Convert given model String into Object
		model=model.constantize.all
		columns=@keys_to_show+model.column_names-@keys_to_ignore

		# HEADER
		# Makes default headers based on column names
		columns.each {|key|
			if key[-3..-1]=='_id'
				key=key[0...-3]
			end
			@thead+="\n\t\t\t<th>"+key.gsub('_',' ').titleize+'</th>'
		}
		@thead+="\n\t\t\t<th>Action</th>"

		# BODY
		# Makes table from given model and row limit, if any
		if rest.length
			limit=model.length-1
			# Set limit to custom value if not nil, 0, or model.length
			if ![nil,0,model.length].include?(rest[1])
				limit=rest[1]-1
			end

			# Makes <tr>s from models array until specified or default limit
			model[0..limit].each {|user|
				@tbody+="\n\t\t<tr>"
				# Makes merged columns, if specified
				if @combination.length!=0
					all_vals=[]
					@combination.each { |col| all_vals.push(user.attributes[col].to_s) }
					@tbody+="\n\t\t\t<td>"+all_vals.join(" ")+'</td>'
				end

				# Makes <td>s
				user.attributes.except(*@keys_to_ignore).each {|key,val|
					if key[-3..-1]=='_id'
						# Use '.keys' & '.values' to get certain # key or value from hash
						val=key[0...-3].capitalize.constantize.find(val).attributes.values[val]
					elsif key=='created_at' || key=='updated_at'
						val=val.strftime("%b %d, %Y %I:%M %p")
					end
					@tbody+="\n\t\t\t<td>"+val.to_s+'</td>'
				}

				# Generates (C)RUD links
				crud="\n\t\t\t<td><a href=\"/"+controller+"/"+user.id.to_s+"\">Show</a> | <a href=\"/"+controller+"/"+user.id.to_s+"/edit\">Edit</a> | <a href=\"/"+controller+"/"+user.id.to_s+"\" data-method=\"delete\">Delete</a></td>"
				@tbody+=crud+"\n\t\t</tr>"
			}
		end
		return self
	end

	# Makes custom headers
	def th *ths
		@thead=''
		ths.each { |custom_header| @thead+="\n\t\t\t<th>%s</th>" % custom_header }
		return self
	end

	# Makes custom-sized table; send in 0 for default col/row #
	def custom columns,rows
		for row in 1..rows
			@tbody+="\n\t\t<tr>"
			for column in 1..columns
				@tbody+="\n\t\t\t<td></td>"
			end
			@tbody+="\n\t\t</tr>"
		end
		return self
	end

	# Writes table html code to 'table_html.txt' file located in application's root folder
	def file
		File.open('table_html.txt', 'w') { |f| f.write(("<table>\n\t<thead>\n\t\t<tr>"+@thead+"\n\t\t</tr>\n\t</thead>\n\t<tbody>"+@tbody+"\n\t</tbody>\n</table>")) }
		return self
	end

	# Generates for loop code in 'table_html.txt'
	def for!
		# "<table>\n\t<thead>\n\t\t<tr>"+@thead+"\n\t\t</tr>\n\t</thead>\n\t<tbody><% for |row| in "++"\n\t</tbody>\n</table>"
	end

	# Place table code into view
	def now!
		return ('<table><thead><tr>'+@thead+'</tr></thead><tbody>'+@tbody+'</tbody></table>').html_safe
	end
end