# make

**Make** is a Ruby on Rails gem that takes content from your database to generate html code for forms and tables.

By [UlyssesLin](http://github.com/UlyssesLin) and [sarapple](http://github.com/sarapple).

This gem is designed for every web developer who tediously typed out all the necssary `<tr>`, `<td>` and `<inputs>`, only to have to re-create another form and table again tailored to a new model. 

At its most basic usage, you can call Make.form.model('ModelName').now! or Make.form.model('ModelName').now!, and in very small code generate the necessary fields and columns associated with that Model, and any related Models for quick building and displaying of database info. 

Optional parameters are passed in via chaining methods, which will be discussed in detail below.

## Demo

Please view Demo Site for detailed information and how to chain our functions.
[DemoSite](https://make-gem.herokuapp.com/)

## Setup

Add it to your Gemfile:

```rb
gem 'make'
```

Run the following command to install it:

```
bundle install
``` 

Add the following line to your controllers/application_controller.js to make the gem available throughout your application, and you can call Make without requiring it in every controller.

```rb
require 'make'
``` 
## Basic Usage

The following examples assume 'User' as the name of your model.

### Building a Basic Table

Add directly to your controller:
```rb
require 'make'
@users=Make.form.model('User').now!
```
View file:
```erb
<%= @users %>
```

The gem will auto-make headers for you based on column names.

### Building a Basic Form

In your controller:
```rb
require 'make'
@userForm=Make.form.model('User').now!
```
In your corresponding view file:
```erb
<%= @userForm %>
```

Your config/routes.rb should include either:
```rb
resources :users
```
OR
```rb
post '/users'
```

### Generic HTML Header (specifies UTF-8)

The header populates with generic header content in English. This function is recommended in your layout files.

```erb
<head>
<%= Make.header('MyTitle') %>
</head>
```




## Optional Fields

## TABLE
### Making custom headers

Creates a custom headers.

In your controller: 

```rb
@users=Make.table.model('Person').th('First','Second','Third','Fourth','Fifth','Sixth','Seventh').now!
```
In your view
```erb
<%= @users %>
```

### Ordering your rows

Orders the data by ASC/DESC.

In your controller: 

```rb
@users=Make.table.model('Person').order('first_name ASC').now!
```
In your view
```erb
<%= @users %>
```

### Cutting default columns

Hides a column that would otherwise display by default.

In your controller: 

```rb
@users=Make.table.model('Person').cut('first_name','middle_name').now!
```
In your view
```erb
<%= @users %>
```

### Limiting row length

Limits the number of rows shown by the given integer; note: do not pass a string.

In your controller: 

```rb
@users=Make.table.model('Person').limit(4).now!
```
In your view
```erb
<%= @users %>
```

### Combining columns

Combines multiple columns into one and creates a name for that new column; you must pass in a hash.

In your controller: 

```rb
@users=Make.table.model('Person').combo({'Full Name'=>['first_name','middle_name','last_name']}).now!
```
In your view
```erb
<%= @users %>
```

### Show hidden columns

Displays a column that by default would be hidden (i.e., 'id', 'created_at', 'updated_at'. Any column containing passwords are always hidden.

In your controller: 

```rb
@users=Make.table.model('Person').show('id').now!
```
In your view
```erb
<%= @users %>
```

### Write literal html code to file

Prints complete html table code in table_html.txt (located in your root application folder)! Just copy it and paste into your html file(s)!

In your controller: 

```rb
@users=Make.table.model('Person').file!
```
In your view
```erb
<%= @users %>
```

### Write for loop html code to file

Prints shorter html table code using for loops in table_html.txt (located in your root application folder)! Just copy it and paste into your html file(s) - note the comment and the line of code needed for your controller file.

In your controller: 

```rb
@users=Make.table.model('Person').for!('@people')
```
In your view
```erb
<%= @users %>
```

### Finalizing your method chain with .now!

Finally renders your table in your chosen view file. If your controller has a line like '@table=Main.table.model('Person').file.now!', then your view file should have '<%= @table %>' - that's it!

In your controller: 

```rb
@users=Make.table.model('Person').now!
```
In your view
```erb
<%= @users %>
```

### Generating empty custom table

Creates a custom-size table with empty cells. Should combine with .th

In your controller: 

```rb
@users=Make.table.custom(5,15).th('First','Second','Third','Fourth','Fifth').file!
```
In your view
```erb
<%= @users %>
```



## FORM
### Adding default values to Form

If you have a default hidden value to specify in your form, chain as shown in your controller:

```rb
require 'make'
@userForm = Make.form.model('User').defaults(admin: false)
```
In your view:
```erb
<%= @userForm %>
```

### Requiring a confirmation password

By default, if any of your field contain the word password, your input will contain a password field.  The next field defaults to providing a password_confirmation field, but can be turned off manually.

```rb
require 'make'
@userForm = Make.form.model('User').no_pw_confirm.now!
```
In your view:
```erb
<%= @userForm %>
```

### Select Options

.select() expects two parameters at minimum, (1) the target column name and an (2) array of values/options.

```rb
require 'make'
@userForm = Make.form.model('User').select('pets', [1,2,3,4,5])
```
In your view:
```erb
<%= @userForm %>
```

### Select Options - Association Exists

.select() can also take a third optional parameter, if the values in the array are indexes for anoter table column.

This will take each of the id values from pet_id, go to your Pets model (based on convention) and translate it to the corresponding name in the selection options, [cat, dog, rabbit, hamster, platypus], although the option value will retain the id for convenience.

```rb
require 'make'
@userForm = Make.form.model('User').select('pet_id', [1,2,3,4,5], assoc=true)
```
In your view:
```erb
<%= @userForm %>
```

## Thank you!

**Make** gem is current, still under construction, and will be maintained until noted otherwise. For any bugs or Ruby-istic concerns, please create an issue on GitHub. 
