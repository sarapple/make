class Table
	def initialize
		@thead=''
		@tbody=''
		# These are the table keys to ignore when rendering table
		@keys_to_ignore=['id','created_at','updated_at']
		@keys_to_show=[]
		@combination=[]
		@columns=[]
		@crud=''
		@all_columns=[]
		@run_make_head=true
		@file=false
	end

	# Assigns desired column names to be combined
	def combo cols
		cols.each { |result,parts|
			@combination=parts
			@keys_to_ignore+=parts
			@keys_to_show.push(result)
		}
		# remake_columns
		return self
	end

	# Assigns previously hidden column names as to be shown
	def show *to_show
		@keys_to_ignore-=to_show
		return self
	end

	# Must provide model as a String, uppercase
	def model model,*rest
		@controller=model.downcase.pluralize
		# Convert given model String into Object with .constantize
		@model=model.constantize.all
		@all_columns=@model.column_names
		@limit=@model.length-1
		# remake_columns
		return self
	end

	# Defines column(s) to ignore
	def cut *columns
		@keys_to_ignore+=columns
		# remake_columns
		return self
	end

	# Redefines columns after some change
	def remake_columns
		@columns=@keys_to_show+@all_columns-@keys_to_ignore
	end

	# Defines row limit
	def limit row
		@limit=row-1
		return self
	end

	# Defines order
	def order rule
		@model=@model.order(rule)
		return self
	end

	def make_head
		# HEADER
		# Makes default headers based on column names
		@columns.each {|key|
			if key[-3..-1]=='_id'
				key=key[0...-3]
			end
			# Ignores any column name containing "password"
			if key.include? "password"
				@keys_to_ignore.push(key)
			else
				@thead+="\n\t\t\t<th>"+key.gsub('_',' ').titleize+'</th>'
			end
		}
		@thead+="\n\t\t\t<th>Action</th>"
	end

	# Makes table from given model and row limit, if any
	def make_body
		# Set limit to custom value if not nil, 0, or @model.length


		# Makes <tr>s from @model array until specified or default limit
		@model[0..@limit].each {|user|
			@tbody+="\n\t\t<tr>"
			# Makes merged columns, if specified
			if @combination.length!=0
				all_vals=[]
				@combination.each { |col| all_vals.push(user.attributes[col].to_s) }
				@tbody+="\n\t\t\t<td>"+all_vals.join(" ")+'</td>'
			end

			# Makes <td>s
			user.attributes.except(*@keys_to_ignore).each {|key,val|
				# Auto connects with related table
				if key[-3..-1]=='_id'
					@temp=val
					# Use '.keys' & '.values' to get certain # key or value from hash
					# .values[1] grabs column after 'id'
					val=key[0...-3].capitalize.constantize.find(val).attributes.values[1]
				elsif key=='created_at' || key=='updated_at'
					val=val.strftime("%b %d, %Y %I:%M %p")
				end
				@tbody+="\n\t\t\t<td>"+val.to_s+'</td>'
			}

			# Generates (C)RUD links
			@tbody+="\n\t\t\t"+crud(user.id.to_s)+"\n\t\t</tr>"
		}
		# return self
	end

	def crud id
		return "<td><a href=\"/"+@controller+"/"+id+"\">Show</a> | <a href=\"/"+@controller+"/"+id+"/edit\">Edit</a> | <a href=\"/"+@controller+"/"+id+"\" data-method=\"delete\">Delete</a></td>"
	end

	# Makes custom headers
	def th *ths
		@thead=''
		ths.each { |custom_header| @thead+="\n\t\t\t<th>%s</th>" % custom_header }
		@run_make_head=false
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
	def file!
		remake_columns
		if @run_make_head
			make_head
		end
		make_body
		@file=true
		File.open('table_html.txt', 'w') { |f| f.write(("<table>\n\t<thead>\n\t\t<tr>"+@thead+"\n\t\t</tr>\n\t</thead>\n\t<tbody>"+@tbody+"\n\t</tbody>\n</table>")) }
		return self
	end

	# Generates for loop code in 'table_html.txt'
	def for! variable
		@columns=@all_columns
		if @run_make_head
			make_head
		end
		singular=variable[1..-1].singularize
		tds=''
		@all_columns.each { |col| tds+="\n\t\t\t\t<td><%= "+singular+"['"+col+"'] %></td>" if !col.include? "password" }
		tds+="\n\t\t\t\t"+crud("<%= "+singular+"['id'] %>")
		File.open('table_html.txt', 'w') { |f| f.write(("<table>\n\t<thead>\n\t\t<tr>"+@thead+"\n\t\t</tr>\n\t</thead>\n\t<tbody>\n\t\t<% for |"+singular+"| in "+variable+" do %>\n\t\t\t<tr>"+tds+"\n\t\t\t</tr>\n\t\t<% end %>\n\t</tbody>\n</table>\n\n\n<--! PUT THE FOLLOWING LINE INTO YOUR CONTROLLER -->\n"+variable+" = "+singular.capitalize+".all")) }
		return self
	end

	# Place table code into view
	def now!
		if !@file
			remake_columns
			if @run_make_head
				make_head
			end
			make_body
		end	
		return ('<table><thead><tr>'+@thead+'</tr></thead><tbody>'+@tbody+'</tbody></table>').html_safe
	end
end