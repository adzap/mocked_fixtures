= mocked_fixtures

* Project page: http://mockedfixtures.rubyforge.com/
* Contribute:   http://github.com/adzap/mocked_fixtures
* Tickets:      http://adzap.lighthouseapp.com/
* Discuss:      http://groups.google.com/mocked_fixtures

== DESCRIPTION:

Yes, lets laugh at those silly fixtures with their silly yaml or comma 
separated values! Ha ha ha! Don't they know how passe they are. All the cool kids
are mocking and stubbing. Get with the times fixtures!

Well actually fixtures still have their place. Especially with the foxy fixtures
extensions added to Rails 2.0, they are now much easier to use. Problem is the 
undesirably database overhead that comes with reloading your fixtures for every 
test. For controller and view tests the database layer should is not be your 
concern and violates good test isolation.

This plugin helps by allowing you use your fixtures as disconnected mocked 
objects which never touch the database when loaded or used. So you can now 
keep using those thoughtfully crafted fixtures in your controller and view tests
but minus the database overhead.

A mocked fixture is a mocked model object with all the model attributes stubbed
out to return the values from the fixture if defined. If no fixture value was 
defined then a nil is returned for the attribute method as you would expect.
There are no attribute setters defined on the object as they are left for you 
to do as necessary.

The attributes for each model are read from you schema.rb file to avoid any 
database access at all!

== FEATURES/DISCLAIMER:

* reuse your fixtures without any database overhead
* adds feature to common mocking libraries to quickly create empty mocked model
  with all attributes methods stubbed out to return nil
* same familiar style of using regular fixtures
* works with other testing frameworks such as rspec_on_rails, test/unit, 
  test/spec and any testing library which uses test/unit

DISCLAIMER: 
This plugin is tightly coupled to the ActiveRecord fixtures 
implementation to get full benefit of the foxy fixtures features, therefore 
will likely break with changes to the fixtures code.

== SYNOPSIS:

To get going you need to require the plugin at the top of your test_helper or 
spec_helper file

  require 'mocked_fixtures'

If you are using Rspec then this line must go *above* the require for 
rspec_on_rails, like so

  require 'mocked_fixtures'
  require 'spec/rails'
	
Now if you have a Company model and fixture for the model like this

megacorp:
  name: Mega Corporation
  moto: Do Evil
	
So just like normal fixtures you declare which ones you want to use in your test
or spec

	mock_fixtures :companies

	before do
		@company = mock_companies(:megacorp)
		@company.moto # returns 'Do Evil'
	end

You get back the 'megacorp' fixture as a mocked model object and calling any 
attribute method will return the value defined in you fixture. Easy!

Thats all for now, so mock on!

NOTE:
If you use MS SQL Server then you need to apply a fix for this adapter to 
correctly dump primary keys when not named 'id'. Just drop this line in an 
initializer file

  require 'mocked_fixtures/connection_adapters/sqlserver_adapter'

You then need to do a dump. Um, keep your pants on, I mean a database dump with
  
  rake db:schema:dump

Now the schema.rb file should be complete if the above applies to you.

== REQUIREMENTS:

* test/unit

and one of:

* spec/mock (included with Rspec)
* flexmock
* mocha

== INSTALL:

* sudo gem install mocked_fixtures

== LICENSE:

(The MIT License)

Copyright (c) 2008 Adam Meehan

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
