openssl Cookbook
================
Provide a library method to generate secure random passwords in recipes.

Requirements
------------
Works on any platform with OpenSSL Ruby bindings installed, which are a requirement for Chef anyway.


Usage
-----
Most often this will be used to generate a secure password for an attribute.

```ruby
include Opscode::OpenSSL::Password
set_unless[:my_password] = secure_password
```


License & Authors
-----------------
- Author:: Joshua Timberman (<joshua@opscode.com>)

```text
Copyright:: 2009-2011, Opscode, Inc

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
