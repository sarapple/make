# make

**Make** is a Ruby on Rails gem that takes content from your database to generate html code for forms and tables.

By [UlyssesLin](http://github.com/UlyssesLin) and [sarapple](http://github.com/sarapple).

This gem is designed for every web developer who tediously typed out all the necssary `<tr>`, `<td>` and `<inputs>`, only to have to re-create another form and table again tailored to a new model. 

At its most basic usage, you can call Make.form.model('ModelName').now! or Make.form.model('ModelName').now!, and in very small code generate the necessary fields and columns associated with that Model for quick building and displaying of database info. 

Optional parameters are passed in via chaining methods, which will be discussed in detail below.

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

### Building a Customized Table

In your controller: 

```rb
@message=Make.table.model('User')....now!
```
In your view
```erb
<%= @message %>
```
The ellipsis above contains optional parameters, all of which are chained one after another. The now! at the end compiles all the chained requests into a tailored table.

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
@userForm = Make.form.model('User').confrimation(false)
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