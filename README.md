# make

**Make** is a Ruby on Rails gem that connects your database to viewable html.

By [UlyssesLin](http://github.com/UlyssesLin) and [sarapple](http://github.com/sarapple).

At its most basic usage, you can call Make.form(ModelName) or Make.table(ModelName.all), and display the necessary fields and columns associated with that Model for quick building and displaying of database info. 

We also have optional parameters you can pass in, if so desired.

## Setup

Add it to your Gemfile:

```
gem 'make'
```

Run the following command to install it:

```
bundle install
``` 

Add the following line to your controllers/application_controller.js to make the gem available throughout your application.

```js
require 'make'
``` 
## Basic Usage

The following examples assume 'User' as the name of your model.

### Building a Basic Table

Add directly to your view: 

```erb
<%= Make.table(User.all) %>
```

Alternatively, for cleaner code add to your controller:

```rb
require 'make'
@message=Make.table(User.all)
```
```erb
<%= @message %>
```

In your controller, all you have to do is call Make.table on a table in your database.

The gem will auto-make headers for you based on column names.

### Building a Basic Form

In your view file:

```erb
<%= Make.form(User) %>
```

Your routes should include either:

```rb
resources :users
```
OR
```rb
post '/users'
```

### Generic HTML Header (specifies UTF-8)

The header populates with generic header content in English. This function is recommended 

```erb
<head>
<%= Make.header('MyTitle') %>
</head>
```

## Optional Fields

### Building a Customized Table

In your controller: 

```rb
@message=Make.table(User.all,['First Name','Last Name','Email Address'],0,1)
```

In your view
```erb
<%= @message %>
```
The above are optional parameters, consisting of table headers, custom column #, and custom row #.

If you put '0' in for the model name, you make a custom table.

If you put '0' in for custom col/row #, the gem interprets this as you want a full table of everything in the database.

### Adding default values to Form

If you have one or more default values that you must specify in your form, send the following optional parameter with 'default' as the key:

{ default: { field1_name: field1_value }, { field2_name: fiel2d_value } }

In your view file:

```erb
<%= Make.form(Comment, { default: { post_id: post.id, user_id: session[:id] }}) %>
```

## Thank you!

**Make** gem is current, still under construction, and will be maintained until noted otherwise. For any bugs or Ruby-istic concerns, please create an issue on GitHub. 