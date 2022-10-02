require File.expand_path('../support/helpers.rb', __FILE__)

describe 'mysql::server' do

  include Helpers::Mysql

  it 'has a secure operating system password' do
    assert_secure_password(:debian)
  end
  it 'has a secure root password' do
    assert_secure_password(:root)
  end
  it 'has a secure replication password' do
    assert_secure_password(:repl)
  end
  it 'installs the mysql packages' do
    node['mysql']['server']['packages'].each do |package_name|
      package(package_name).must_be_installed
    end
  end
  it 'has a config directory' do
    directory(node['mysql']['confd_dir']).must_exist.with(:owner, 'mysql').and(:group, 'mysql')
  end
  it 'runs as a daemon' do
    service(node['mysql']['service_name']).must_be_running
  end
  it 'creates a my.cnf' do
    file("#{node['mysql']['conf_dir']}/my.cnf").must_exist
  end
  describe 'debian' do
    it 'creates a config file for service control' do
      skip unless ['debian'].include?(node['platform_family'])
      file("#{node['mysql']['conf_dir']}/debian.cnf").must_exist
    end
  end
end
