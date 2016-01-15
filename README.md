# Rails Lite

MVC framework written in Ruby, inspired by the main functionality of Rails.
Includes ActiveRecord Lite, a lightweight object-relational mapper (ORM) between Ruby and SQL.

The purpose of this Rails Lite project is to demonstrate an understanding of the Ruby on Rails framework and MVC frameworks in general as well as ORMs and ActiveRecord assisted SQL queries.

## Server Infrastructure

Rails Lite uses a Rack server, which is located in `bin/router_server`. The API handles HTTP requests and responses.
### Stack Tracer


### Static Assets

Static assets contained in `/public/` are made available when a GET request is submitted with `/public/` after the hostname.

The Static server at `bin/static_server` matches the requested path and responds with the asset at the corresponding location.

## Architecture and MVC

Rails Lite includes a custom router, controller base, and model base(ActiveRecord Lite)

### Router
The router uses metaprogramming to dynamically create routes for each controller action. It runs routes to call controller actions corresponding to passed requests.

### Controller Base
The Controller Base roughly corresponds to Rails' ActionController::Base, providing standard methods to user-defined controllers. Methods include `#render`, `#redirect_to`, `#session`, and `#flash`.


### Model Base
ActiveRecord Lite's Model Base (`active_record_lite/model_base.rb`) is a lightweight version of Rails' ActiveRecord::Base which provides base methods for user-generated models. It includes standard query methods `#all`, `#find` `#insert`, `#update` and `#save`.

Model Base also allows access to methods from the extended Associatable and Searchable modules found in `active_record_lite/associatable` and `active_record_lite/searchable`.


## Additional Features

### Session
Authenticates user session using Rack cookie setter and getter methods.

### Flash

Displays notifications  to the client either immediately on render using `Flash#now` or after a redirect by storing a cookie.

### CSRF Protection
Protects against cross-ste request forgery (CSRF) attacks by setting and validating authentication tokens.
