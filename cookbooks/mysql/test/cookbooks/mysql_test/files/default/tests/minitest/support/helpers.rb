module Helpers
  module Mysql
    include MiniTest::Chef::Assertions
    include MiniTest::Chef::Context
    include MiniTest::Chef::Resources

    def assert_secure_password(type)
      node["mysql"]["server_#{type}_password"].length.must_be_close_to(20, 8)
    end
  end
end
