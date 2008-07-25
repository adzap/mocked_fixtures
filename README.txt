= mocked_fixtures

* Project page: http://mockedfixtures.rubyforge.com/
* Tickets:      http://adzap.lighthouseapp.com/
* Contribute:   http://github.com/adzap/mocked_fixtures
* Discuss:      http://groups.google.com/mocked_fixtures
* Blog:         http://duckpunching.com/


== DESCRIPTION:

Yes, lets laugh at those silly fixtures with their silly yaml or comma 
separated values! Ha ha ha! Don't they know how passe they are. All the cool kids
are mocking and stubbing. Get with the times fixtures!

Well actually fixtures still have their place. Especially with the foxy fixtures
extensions added to Rails 2.0, they are now much easier to use. Problem is the 
undesirable database overhead that comes with reloading your fixtures for every 
test. Also, in controller and view tests, the database layer is unnecessary and 
using mock objects is often preferred.

This poses another challenge of the often tedious creation those mocks to return
the values you need for testsm much like you did for your fixtures. But what if 
you could reuse those fixtures as mocks where you don't need real ActiveRecord 
objects. Well thats where mocked_fixtures comes in.

This plugin helps by allowing you use your fixtures as disconnected mock objects
which never touch the database when loaded or used. So you can now keep using 
those thoughtfully crafted fixtures in your controller and view tests but minus
the database overhead.

A mocked fixture is a mock model object with all the model attributes stubbed
out to return the values from the fixture if defined. If no fixture value was 
defined then a nil is returned for the attribute method as you would expect.
There are no attribute setters defined on the object as they are left for you 
to do as necessary.

The attributes for each model are read from the schema.rb file to avoid any 
database access at all!

== FEATURES/PROBLEMS:

 * Reuse your fixtures as mock model objects without database overhead
 * Adds feature to supported mocking libraries to quickly create empty mocked
   model with all attributes methods stubbed out. Supported are Rspec, flexmock
   and mocha.
 * Same familiar style of using regular fixtures
 * Works with popular testing frameworks such as Rspec (with rspec_on_rails),
   shoulda and any testing library which uses good old test/unit as its base.

What it doesn't do:

 * Touch the database. This means that the fixtures are not inserted in the 
   tables, thats not what the plugin is for.
 * Create mock objects with the attribute setters. Only reader methods.

== SYNOPSIS:

To get going you need to require the plugin at the top of your test_helper or 
spec_helper file. For test/unit add it after the test/unit require like so
  
  require 'test/unit'
  require 'mocked_fixtures'

If you are using Rspec then this line must go *above* the require for
rspec_on_rails, like so

  require 'spec'
  require 'mocked_fixtures'
  require 'spec/rails'

If you are using test/unit then you need specify which mocking library you 
are using. You need to add this to your test_helper

  class Test::Unit::TestCase
    
    # can be one of :flexmock or :mocha
    self.mocked_fixtures_mock_with = :flexmock  
  end
  
If you are using Rspec then the mocking library will be automatically set to
default Rspec mocking library or which ever one you have set using the config
mock_with option. If you are using something other than the supported libraries
then you get an error alerting the plugin can't be used with that library.
  
On to the good stuff. Now if you have a Company model and fixture for the model
like this

  megacorp:
    name: Mega Corporation
    moto: Do Evil

Just like normal fixtures you declare which ones you want to use in your test
or spec at the top

  class MyTest < Test::Unit:TestCase
	  mock_fixtures :companies

	  def setup
		  @company = mock_companies(:megacorp)		  
	  end
	  
	  def test_does_something
	    assert_equal @company.moto, 'Do Evil'
	  end
  end
  
All the attributes will be stubbed to return the values from the fixture. The 
fixture is generated using the internal Rails fixtures class, so any of fixture
tricks, such as association labels and automatically generated ids, will work.

If you want more than one fixture, then like normal fixtures you list the 
fixture keys to get back an array of the objects.

  @companies = mock_companies(:megacorp, :bigstuff)


To quickly grab all of the fixtures you call use the :all option

  @companies = mock_companies(:all)



Thats all for now, so mock on!

NOTE:
If you use MS SQL Server then you need to apply a fix for this adapter to 
correctly dump primary keys when not named 'id'. Just drop this line in an 
initializer file

  require 'mocked_fixtures/connection_adapters/sqlserver_adapter'

You then need to do a dump. Um, keep your pants on, I mean a database dump with
  
  rake db:schema:dump

Now the schema.rb file should be complete.

== REQUIREMENTS:

* Spec::Mock (included with Rspec)
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
