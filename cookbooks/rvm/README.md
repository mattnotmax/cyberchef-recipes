# <a name="title"></a> chef-rvm [![Build Status](https://secure.travis-ci.org/fnichol/chef-rvm.png?branch=master)](http://travis-ci.org/fnichol/chef-rvm)

## <a name="description"></a> Description

Manages system-wide and per-user [RVM][rvm]s and manages installed Rubies.
Several lightweight resources and providers ([LWRP][lwrp]) are also defined.

## <a name="usage"></a> Usage

### <a name="usage-system-rubies"></a> RVM Installed System-Wide with Rubies

Most likely, this is the typical case. Include `recipe[rvm::system]` in your
run_list and override the defaults you want changed. See below for more
details.

### <a name="usage-user-rubies"></a> RVM Installed For A Specific User with Rubies

If you want a per-user install (like on a Mac/Linux workstation for
development), include `recipe[rvm::user]` in your run_list and add a user
hash to the `user_installs` attribute list. For example:

    node['rvm']['user_installs'] = [
      { 'user'          => 'wigglebottom',
        'default_ruby'  => 'rbx',
        'rubies'        => ['1.9.2', '1.8.7']
      }
    ]

See below for more details.

### <a name="usage-system"></a> RVM Installed System-Wide and LWRPs Defined

If you want to manage your own RVM environment with the provided [LWRP][lwrp]s,
then include `recipe[rvm::system_install]` in your run_list to prevent
a default RVM Ruby being installed. See the **Resources and Providers**
section for more details.

### <a name="usage-user"></a> RVM Installed For A Specific User and LWRPs Defined

If you want to manage your own RVM environment for users with the provided
LWRPs, then include `recipe[rvm::user_install]` in your run_list and add a
user hash to the `user_installs` attribute list. For example:

    node['rvm']['user_installs'] = [
      { 'user' => 'wigglebottom' }
    ]

See the **Resources and Providers** section for more details.

### <a name="usage-minimal"></a> Ultra-Minimal Access To LWRPs

Simply include `recipe[rvm]` in your run_list and the LWRPs will be available
to use in other cookbooks. See the **Resources and Providers** section for
more details.

### <a name="usage-other"></a> Other Use Cases

* If node is running in a Vagrant VM, then including `recipe[rvm::vagrant]`
in your run_list can help with resolving the *chef-solo* binary on subsequent
provision executions.
* If you want other Chef cookbooks to install RubyGems in RVM-managed Rubies,
you can try including `recipe[rvm::gem_package]` in your run_list. Please
read the recipe details before attempting.

## <a name="requirements"></a> Requirements

### <a name="requirements-chef"></a> Chef

Tested on 0.10.2/0.10.4 and 0.9.16 but newer and older versions (of 0.9.x)
should work just fine. Due to the `rvm_gem` implementation, versions 0.8.x
of Chef currently will **not** work (see [GH-50][gh50]).

File an [issue][issues] if this isn't the case.

### <a name="requirements-platform"></a> Platform

The following platforms have been tested with this cookbook, meaning that
the recipes and LWRPs run on these platforms without error:

* ubuntu (10.04/10.10/11.04/12.04)
* debian (6.0)
* mac_os_x (10.6/10.7) (See [Platform Notes](#platform-notes-osx))
* mac_os_x_server (See [Platform Notes](#platform-notes-osx))
* suse (openSUSE, SLES)
* centos
* amazon (2011.09)
* scientific
* redhat
* fedora
* gentoo

Please [report][issues] any additional platforms so they can be added.

### Platform Notes

#### <a name="platform-notes-osx"></a> OSX

This cookbook suggests the [homebrew](http://community.opscode.com/cookbooks/homebrew) cookbook, which is needed to install
any additional packages needed to compile ruby. RVM now ships binary rubies,
but will require homebrew to install any additional libraries.

### <a name="requirements-cookbooks"></a> Cookbooks

This cookbook depends on the following external cookbooks:

* [chef\_gem][chef_gem_cb]

If you are installing [JRuby][jruby] then a Java runtime will need to be
installed. The Opscode [java cookbook][java_cb] can be used on supported
platforms.

## <a name="installation"></a> Installation

Depending on the situation and use case there are several ways to install
this cookbook. All the methods listed below assume a tagged version release
is the target, but omit the tags to get the head of development. A valid
Chef repository structure like the [Opscode repo][chef_repo] is also assumed.

### <a name="installation-berkshelf"></a> Using Berkshelf

[Berkshelf][berkshelf] is a way to manage a cookbook or an application's
cookbook dependencies. Include the cookbook in your Berksfile, and then run
`berks install`. To install using Berkshelf:

    gem install berkshelf
    cd chef-repo
    berks init
    echo "cookbook 'rvm', github: 'fnichol/chef-rvm'" >> Berksfile
    berks install

### <a name="installation-librarian"></a> Using Librarian-Chef

[Librarian-Chef][librarian] is a bundler for your Chef cookbooks.
Include a reference to the cookbook in a [Cheffile][cheffile] and run
`librarian-chef install`. To install Librarian-Chef:

    gem install librarian
    cd chef-repo
    librarian-chef init
    cat >> Cheffile <<END_OF_CHEFFILE
    cookbook 'rvm',
      :git => 'git://github.com/fnichol/chef-rvm.git', :ref => 'v0.9.0'
    END_OF_CHEFFILE
    librarian-chef install

### <a name="installation-kgc"></a> Using knife-github-cookbooks

The [knife-github-cookbooks][kgc] gem is a plugin for *knife* that supports
installing cookbooks directly from a GitHub repository. To install with the
plugin:

    gem install knife-github-cookbooks
    cd chef-repo
    knife cookbook github install fnichol/chef-rvm/v0.9.0

### <a name="installation-gitsubmodule"></a> As a Git Submodule

A common practice (which is getting dated) is to add cookbooks as Git
submodules. This is accomplishes like so:

    cd chef-repo
    git submodule add git://github.com/fnichol/chef-rvm.git cookbooks/rvm
    git submodule init && git submodule update

**Note:** the head of development will be linked here, not a tagged release.

### <a name="installation-tarball"></a> As a Tarball

If the cookbook needs to downloaded temporarily just to be uploaded to a Chef
Server or Opscode Hosted Chef, then a tarball installation might fit the bill:

    cd chef-repo/cookbooks
    curl -Ls https://github.com/fnichol/chef-rvm/tarball/v0.9.0 | tar xfz - && \
      mv fnichol-chef-rvm-* rvm

### <a name="installation-platform"></a> From the Opscode Community Platform

This cookbook is not currently available on the site due to the flat
namespace for cookbooks. There is some community work to be done here.

## <a name="recipes"></a> Recipes

### <a name="recipes-default"></a> default

Installs the RVM gem and initializes Chef to use the Lightweight Resources
and Providers ([LWRPs][lwrp]).

Use this recipe explicitly if you only want access to the LWRPs provided.

### <a name="recipes-system-install"></a> system_install

Installs the RVM codebase system-wide (that is, into `/usr/local/rvm`). This
recipe includes *default*.

Use this recipe by itself if you want RVM installed system-wide but want
to handle installing Rubies, invoking LWRPs, etc..

### <a name="recipes-system"></a> system

Installs the RVM codebase system-wide (that is, into `/usr/local/rvm`) and
installs Rubies, global gems, and specific gems driven off attribute metadata.
This recipe includes *default* and *system_install*.

Use this recipe by itself if you want RVM system-wide with Rubies installed,
etc.

### <a name="recipes-user-install"></a> user_install

Installs the RVM codebase for a list of users (selected from the
`node['rvm']['user_installs']` hash). This recipe includes *default*.

Use this recipe by itself if you want RVM installed for specific users in
isolation but want each user to handle installing Rubies, invoking LWRPs, etc.

### <a name="recipes-user"></a> user

Installs the RVM codebase for a list of users (selected from the
`node['rvm']['user_installs']` hash) and installs Rubies, global gems, and
specific gems driven off attribute metadata. This recipe includes *default*
and *user_install*.

Use this recipe by itself if you want RVM installed for specific users in
isolation with Rubies installed, etc.

### <a name="recipes-vagrant"></a> vagrant

An optional recipe if Chef is installed in a non-RVM Ruby in a
[Vagrant][vagrant] virtual machine. This recipe adds the default *vagrant*
user to the RVM unix group and installs a `chef-solo` wrapper script so Chef
doesn't need to be re-installed in the default RVM Ruby.

### <a name="recipes-gem-package"></a> gem_package

An experimental recipe that patches the [gem_package resource][gem_package]
to use the `Chef::Provider::Package::RVMRubygems` provider. An attribute
`rvm/gem_package/rvm_string` will determine which RVM Ruby is used for
install/remove/upgrade/purge actions. This may help when using a third
party or upstream cookbook that assumes a non-RVM managed system Ruby.

**Note:** When this recipe is included it will force RVM to be
installed in the [compilation phase][compilation]. This will ensure that all
Rubies can be available if any `gem_package` resource calls are issued from
other cookbooks during the compilation phase.

**Warning:** [Here be dragons][dragons]! This is either brilliant or the
dumbest idea ever, so feedback is appreciated.

## <a name="attributes"></a> Attributes

### <a name="attributes-default-ruby"></a> default_ruby

The default Ruby for RVM installed system-wide. If the RVM Ruby is not
installed, it will be built as a pre-requisite. The value can also contain a
gemset in the form of `"ruby-1.8.7-p352@awesome"`.

The default is `"ruby-2.0.0-p0"`. To disable a default Ruby from being
set, use an empty string (`""`) or a value of `"system"`.

### <a name="attributes-user-default-ruby"></a> user_default_ruby

The default Ruby for RVMs installed per-user when not explicitly set for that
user. If the RVM Ruby is not installed, it will be built as a pre-requisite.
The value can also contain a gemset in the form of `"ruby-1.8.7-p352@awesome"`.

The default is `"ruby-2.0.0-p0"`. To disable a default Ruby from being
set, use an empty string (`""`) or a value of `"system"`.

### <a name="attributes-rubies"></a> rubies

A list of additional RVM system-wide Rubies to be built and installed. This
list does not need to necessarily contain your default Ruby as the
`rvm_default_ruby` resource will take care of installing itself. You may also
include patch info and a rubygems version. For example:

    node['rvm']['rubies'] = [
      "ree-1.8.7",
      "jruby",
      {
        'version' => '1.9.3-p125-perf',
        'patch' => 'falcon',
        'rubygems_version' => '1.5.2'
      }
    ]

The default is an empty array: `[]`.

### <a name="attributes-user-rubies"></a> user_rubies

A list of additional RVM Rubies to be built and installed per-user when not
explicitly set. This list does not need to necessarily contain your default
Ruby as the `rvm_default_ruby` resource will take care of installing itself.
For example:

    node['rvm']['user_rubies'] = [ "ree-1.8.7", "jruby" ]

The default is an empty array: `[]`.

### <a name="attributes-global-gems"></a> global_gems

A list of gem hashes to be installed into the *global* gemset in each
installed RVM Ruby sytem-wide. The **global.gems** files will be added to and
all installed Rubies will be iterated over to ensure full installation
coverage. See the `rvm_gem` resource for more details about the options for
each gem hash.

The default puts bundler and rake in each Ruby:

    node['rvm']['global_gems'] = [
      { 'name'    => 'bundler' },
      { 'name'    => 'rake',
        'version' => '0.9.2'
      },
      { 'name'    => 'rubygems-bundler',
        'action'  => 'remove'
      }
    ]

### <a name="attributes-user-global-gems"></a> user_global_gems

A list of gem hashes to be installed into the *global* gemset in each
installed RVM Ruby for each user when not explicitly set. The
**global.gems** files will be added to and all installed Rubies will be
iterated over to ensure full installation coverage. See the `rvm_gem`
resource for more details about the options for each gem hash.

The default puts bundler and rake in each Ruby:

    node['rvm']['user_global_gems'] = [
      { 'name'    => 'bundler' },
      { 'name'    => 'rake',
        'version' => '0.9.2'
      },
      { 'name'    => 'rubygems-bundler',
        'action'  => 'remove'
      }
    ]

### <a name="attributes-gems"></a> gems

A list of gem hashes to be installed into arbitrary RVM Rubies and gemsets
system-wide. See the `rvm_gem` resource for more details about the options for
each gem hash and target Ruby environment. For example:

    node['rvm']['gems'] = {
      'ruby-1.9.2-p280' => [
        { 'name'    => 'vagrant' },
        { 'name'    => 'veewee' },
        { 'name'    => 'rake',
          'version' => '0.9.2'
        }
      ],
      'ruby-1.9.2-p280@empty-gemset' => [],
      'jruby' => [
        { 'name'    => 'nokogiri',
          'version' => '1.5.0.beta.2'
        },
        { 'name'    => 'warbler' }
      ]
    }

The default is an empty hash: `{}`.

### <a name="attributes-user-gems"></a> user_gems

A list of gem hashes to be installed into arbitrary RVM Rubies and gemsets
for each user when not explicitly set. See the `rvm_gem` resource for more
details about the options for each gem hash and target Ruby environment. See
the `gems` attribute for an example.

The default is an empty hash: `{}`.

### <a name="attributes-rvmrc"></a> rvmrc

A hash of system-wide `rvmrc` options. The key is the RVM setting name
(in String or Symbol form) and the value is the desired setting value.
An example used on a build box might be:

    node['rvm']['rvmrc'] = {
      'rvm_project_rvmrc'             => 1,
      'rvm_gemset_create_on_use_flag' => 1,
      'rvm_trust_rvmrcs_flag'         => 1
    }

The default is an empty hash: `{}`.

### <a name="attributes-user-installs"></a> user_installs

A list of user specific RVM installation hashes. The `user_install` and
`user` recipes use this attribute to determine per-user installation settings.
The hash keys correspond to the default/system equivalents. For example:

    node['rvm']['user_installs'] = [
      { 'user'            => 'jdoe',
        'upgrade'         => "head",
        'default_ruby'    => 'ree',
        'rvm_gem_options' => "",
        'global_gems'     => [
          { 'name'    => 'bundler',
            'version' => '1.1.pre.7'
          },
          { 'name'    => 'rake' },
          { 'name'    => 'rubygems-bundler',
            'action'  => 'remove'
          }
        ]
      },
      { 'user'          => 'jenkins',
        'version'       => '1.7.0',
        'default_ruby'  => 'jruby-1.6.3',
        'rubies' => [
          "ree-1.8.7",
          "jruby",
          {
            'version' => '1.9.3-p125-perf',
            'patch' => "falcon",
            'rubygems_version' => '1.5.2'
          }
        ],
        'rvmrc'         => {
          'rvm_project_rvmrc'             => 1,
          'rvm_gemset_create_on_use_flag' => 1,
          'rvm_pretty_print_flag'         => 1
        },
        'global_gems'   => [
          { 'name'    => 'bundler',
            'version' => '1.1.pre.7'
          },
          { 'name'    => 'rake',
            'version' => '0.8.7'
          },
          { 'name'    => 'rubygems-bundler',
            'action'  => 'remove'
          }
        ]
      }
    ]

The default is an empty list: `[]`.

### <a name="attributes-installer-url"></a> installer_url

The URL that provides the RVM installer.

The default is `"https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer"`.

### <a name="attributes-branch"></a> branch

A specific git branch to use when installing system-wide. For example:

    node['rvm']['branch'] = "crazy"

The default is `"stable"` which corresponds to the stable release branch.

### <a name="attributes-version"></a> version

A specific tagged version or head of a branch to use when installing
system-wide. This value is passed directly to the `rvm-installer` script and
current valid values are:

* `"head"` - the default, last git commit on a branch
* a specific tagged version of the form `"1.2.3"`.

You may want to use a specific version of RVM to prevent differences in
deployment from one day to the next (RVM head moves pretty darn quickly).

**Note** that if a version number is used, then `"none"` should be the value
of the `branch` attribute. For example:

    node['rvm']['version'] = "1.13.4"
    node['rvm']['branch']  = "none"

The default is `"head"`.

### <a name="attributes-upgrade"></a> upgrade

Determines how to handle installing updates to the RVM framework system-wide.
The value of this string is passed to `rvm get`. The possible values include:

* `"none"`, `false`, or `nil`: will not update RVM and leave it in its
  current state.
* Any other value is passed to `rvm get` as described on the
  [upgrading][rvm_upgrading] page. For example: `"latest"`, `"stable"`,
  and `"branch mpapis/shoes"`.

The default is `"none"`.

### <a name="attributes-root-path"></a> root_path

The path prefix to RVM in a system-wide installation.

The default is `"/usr/local/rvm"`.

### <a name="attributes-group-id"></a> group_id

The Unix *GID* to be used for the `rvm` group. If this attribute is set,
the group will be created in the compilation phase to avoid any collisions
with expected *GID*s in other cookbooks. If left at the default value,
the RVM installer will create this group as normal.

The default is `default`.

### <a name="attributes-group-users"></a> group_users

A list of users that will be added to the `rvm` group. These users
will then be able to manage RVM in a system-wide installation.

The default is an empty list: `[]`.

### <a name="attributes-rvm-gem-options"></a> rvm_gem_options

These options are passed to the *gem* command in an RVM environment.
In the interest of speed, rdoc and ri docs will not be generated by default.
To re-enable the documentation generation set:

    node['rvm']['rvm_gem_options'] = "--rdoc --ri"

The default is `"--no-rdoc --no-ri"`.

### <a name="attributes-install-rubies"></a> install_rubies (Future Deprecation)

Can enable or disable installation of a default Ruby and additional Rubies
system-wide. For example:

    node['rvm']['install_rubies'] = "false"

The default is `"true"`.

**Note:** This remains a legacy setting and will be deprecated in
the next minor version release.

### <a name="attributes-user-install-rubies"></a> iuser_install_rubies (Future Deprecation)

Can enable or disable installation of a default Ruby and additional Rubies
per user. For example:

    node['rvm']['user_install_rubies'] = "false"

The default is `"true"`.

**Note:** This remains a legacy setting and will be deprecated in
the next minor version release.

### <a name="attributes-gem-package-rvm-string"></a> gem_package/rvm_string

If using the `gem_package` recipe, this determines which Ruby or Rubies will
be used by the `gem_package` resource in other cookbooks. The value can be
either a *String* (for example `ruby-1.8.7-p334`) or an *Array* of RVM Ruby
strings (for example `['ruby-1.8.7-p334', 'system']`). To target an underlying
unmanaged system Ruby you can use `system`.

The default is the value of the `default_ruby` attribute.

### <a name="attributes-vagrant-system-chef-solo"></a> vagrant/system_chef_solo

If using the `vagrant` recipe, this sets the path to the package-installed
*chef-solo* binary.

The default is `"/opt/ruby/bin/chef-solo"`.

## <a name="lwrps"></a> Resources and Providers

### <a name="lwrps-rvmruby"></a> rvm_ruby

#### <a name="lwrps-rvmruby-actions"></a> Actions

<table>
  <thead>
    <tr>
      <th>Action</th>
      <th>Description</th>
      <th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>install</td>
      <td>
        Build and install an RVM Ruby. See RVM rubies/installing<sup>(1)</sup>
        for more details.
      </td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>remove</td>
      <td>
        Remove the Ruby, source files and optional gemsets/archives. See RVM
        rubies/removing<sup>(2)</sup> for more details.
      </td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>uninstall</td>
      <td>
        Just remove the Ruby and leave everything else. See RVM rubies/removing<sup>(3)</sup> for more details.
      </td>
      <td>&nbsp;</td>
    </tr>
  </tbody>
</table>

1. [RVM rubies/installing][rvm_install]
2. [RVM rubies/removing][rvm_remove]
3. [RVM rubies/removing][rvm_remove]

#### <a name="lwrps-rvmruby-actions"></a> Attributes

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>ruby_string</td>
      <td>
        <b>Name attribute:</b> an RVM Ruby string that could contain a gemset.
        If a gemset is given (for example,
        <code>"ruby-1.8.7-p330@awesome"</code>), then it will be stripped.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>user</td>
      <td>
        A users's isolated RVM installation on which to apply an action. The
        default value of <code>nil</code> denotes a system-wide RVM
        installation is being targeted. <b>Note:</b> if specified, the user
        must already exist.
      </td>
      <td><code>nil</code></td>
    </tr>
  </tbody>
</table>

#### <a name="lwrps-rvmruby-examples"></a> Examples

##### Install Ruby

    rvm_ruby "ree" do
      action :install
    end

    rvm_ruby "jruby-1.6.3"

**Note:** the install action is default, so the second example is a more common
usage.

##### Remove Ruby

    rvm_ruby "ree-1.8.7-2011.01" do
      action :remove
    end

**Note:** the RVM documentation mentions that this method is far preferred to
using uninstall since it purges almost everything.

##### Uninstall Ruby

    rvm_ruby "ree-1.8.7-2011.01" do
      action  :uninstall
      user    "jenkins"
    end

**Note:** The RVM installation for the *jenkins* user will be acted upon.

### <a name="lwrps-rvmdefaultruby"></a> rvm_default_ruby

This resource sets the default RVM Ruby, optionally with gemset. The given
Ruby will be installed if it isn't already and a gemset will be created in
none currently exist. If multiple declarations are used then the last executed
one "wins".

#### <a name="lwrps-rvmdefaultruby-actions"></a> Actions

<table>
  <thead>
    <tr>
      <th>Action</th>
      <th>Description</th>
      <th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>create</td>
      <td>
        Set the default RVM Ruby. See RVM rubies/default<sup>(1)</sup> for
        more details.
      </td>
      <td>Yes</td>
    </tr>
  </tbody>
</table>

1. [RVM rubies/default][rvm_default]

#### <a name="lwrps-rvmdefaultruby-attributes"></a> Attributes

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>ruby_string</td>
      <td>
        <b>Name attribute:</b> an RVM Ruby string that could contain a gemset.
        If a gemset is given (for example,
        <code>"ruby-1.8.7-p330@awesome"</code>), then it will be included.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>user</td>
      <td>
        A users's isolated RVM installation on which to apply an action. The
        default value of <code>nil</code> denotes a system-wide RVM
        installation is being targeted. <b>Note:</b> if specified, the
        user must already exist.
      </td>
      <td><code>nil</code></td>
    </tr>
  </tbody>
</table>

#### <a name="lwrps-rvmdefaultruby-examples"></a> Examples

##### Setting The Default Ruby

    rvm_default_ruby "ree" do
      action :create
    end

    rvm_default_ruby "jruby-1.5.6"

**Note:** the create action is default, so the second example is a more common
usage.

### <a name="lwrps-rvmenvironment"></a> rvm_environment

This resource ensures that the specified RVM Ruby is installed and the optional
gemset is created. It is a convenience resource which wraps `rvm_ruby` and
`rvm_gemset` so it can be used as a sort of *über Ruby* resource which
parallels the `rvm_default_ruby` resource.

#### <a name="lwrps-rvmenvironment-actions"></a> Actions

<table>
  <thead>
    <tr>
      <th>Action</th>
      <th>Description</th>
      <th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>create</td>
      <td>Installs the specified RVM Ruby and gemset.</td>
      <td>Yes</td>
    </tr>
  </tbody>
</table>

#### <a name="lwrps-rvmenvironment-attributes"></a> Attributes

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>ruby_string</td>
      <td>
        <b>Name attribute:</b> an RVM Ruby string that could contain a gemset.
        If a gemset is given (for example,
        <code>"ruby-1.8.7-p330@awesome"</code>), then it will be used.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>user</td>
      <td>
        A users's isolated RVM installation on which to apply an action. The
        default value of <code>nil</code> denotes a system-wide RVM
        installation is being targeted. <b>Note:</b> if specified, the
        user must already exist.
      </td>
      <td><code>nil</code></td>
    </tr>
  </tbody>
</table>

#### <a name="lwrps-rvmenvironment-examples"></a> Examples

##### Creating A Passenger Environment In Production

    rvm_environment "ree-1.8.7-2011.01@passenger"

### <a name="lwrps-rvmgemset"></a> rvm_gemset

See [RVM gemsets][rvm_gemsets] for more background concerning gemsets.

#### <a name="lwrps-rvmgemset-actions"></a> Actions

<table>
  <thead>
    <tr>
      <th>Action</th>
      <th>Description</th>
      <th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>create</td>
      <td>
        Creates a new gemset in a given RVM Ruby. See RVM
        gemsets/creating<sup>(1)</sup> for more details.
      </td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>update</td>
      <td>
        Update all gems installed to the gemset in a given RVM Ruby.
      </td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>empty</td>
      <td>
        Remove all gems installed to the gemset in a given RVM Ruby. See RVM
        gemsets/emptying<sup>(2)</sup> for more details.
      </td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>delete</td>
      <td>
        Delete gemset from the given RVM Ruby. See RVM
        gemsets/deleting<sup>(3)</sup> for more details.
      </td>
      <td>&nbsp;</td>
    </tr>
  </tbody>
</table>

1. [RVM gemsets/creating][rvm_create_gemset]
2. [RVM gemsets/emptying][rvm_empty_gemset]
3. [RVM gemsets/deleting][rvm_delete_gemset]

#### <a name="lwrps-rvmgemset-attributes"></a> Attributes

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>gemset</td>
      <td>
        <b>Name attribute:</b> Either an RVM Ruby string containing a gemset
        or a bare gemset name. If only the gemset name is given, then the
        <code>ruby_string</code> attribute must be used to indicate which
        RVM Ruby to target.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>ruby_string</td>
      <td>
        An RVM Ruby string that should not contain a gemset.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>user</td>
      <td>
        A users's isolated RVM installation on which to apply an action. The
        default value of <code>nil</code> denotes a system-wide RVM
        installation is being targeted. <b>Note:</b> if specified, the
        user must already exist.
      </td>
      <td><code>nil</code></td>
    </tr>
  </tbody>
</table>

#### <a name="lwrps-rvmgemset-examples"></a> Examples

##### Creating A Gemset

    rvm_gemset "rails" do
      ruby_string "ruby-1.9.2-p136"
      action      :create
    end

    rvm_gemset "ruby-1.9.2-p136@rails"

**Note:** the create action is default, so the second example is a more common
usage.

##### Updating A Gemset

    rvm_gemset "jruby-1.6.0.RC2@development" do
      action :update
    end

##### Emptying A Gemset

    rvm_gemset "development" do
      ruby_string "jruby-1.6.3"
      action      :empty
    end

##### Deleting A Gemset

    rvm_gemset "ruby-1.9.2-p136@rails" do
      action :delete
    end

### <a name="lwrps-rvmgem"></a> rvm_gem

This resource is a close analog to the `gem_package` provider/resource which
is RVM-aware. See the Opscode [package resource][package_resource] and
[gem package options][gem_package_options] pages for more details.

#### <a name="lwrps-rvmgem-actions"></a> Actions

<table>
  <thead>
    <tr>
      <th>Action</th>
      <th>Description</th>
      <th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>install</td>
      <td>
        Install a gem - if version is provided, install that specific version.
      </td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>upgrade</td>
      <td>
        Upgrade a gem - if version is provided, upgrade to that specific
        version
      </td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>remove</td>
      <td>
        Remove a gem.
      </td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>purge</td>
      <td>
        Purge a gem.
      </td>
      <td>&nbsp;</td>
    </tr>
  </tbody>
</table>

#### <a name="lwrps-rvmgem-attributes"></a> Attributes

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>package_name</td>
      <td>
        <b>Name attribute:</b> the name of the gem to install.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>version</td>
      <td>
        The specific version of the gem to install/upgrade.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>options</td>
      <td>
        Add additional options to the underlying gem command.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>source</td>
      <td>
        Provide an additional source for gem providers (such as RubyGems).
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>gem_binary</td>
      <td>
        A gem_package attribute to specify a gem binary.
      </td>
      <td><code>"gem"</code></td>
    </tr>
    <tr>
      <td>user</td>
      <td>
        A users's isolated RVM installation on which to apply an action. The
        default value of <code>nil</code> denotes a system-wide RVM
        installation is being targeted. <b>Note:</b> if specified, the
        user must already exist.
      </td>
      <td><code>nil</code></td>
    </tr>
  </tbody>
</table>

#### <a name="lwrps-rvmgem-examples"></a> Examples

##### Install A Gem

    rvm_gem "thor" do
      ruby_string "ruby-1.8.7-p352"
      action      :install
    end

    rvm_gem "json" do
      ruby_string "ruby-1.8.7-p330@awesome"
    end

    rvm_gem "nokogiri" do
      ruby_string "jruby-1.5.6"
      version     "1.5.0.beta.4"
      action      :install
    end

**Note:** the install action is default, so the second example is a more common
usage. Gemsets can also be specified.

##### Install A Gem From A Local File

    rvm_gem "json" do
      ruby_string "ree@project"
      source      "/tmp/json-1.5.1.gem"
      version     "1.5.1"
    end

##### Keep A Gem Up To Date

    rvm_gem "homesick" do
      action :upgrade
    end

**Note:** the default RVM Ruby will be targeted if no `ruby_string` attribute
is given.

##### Remove A Gem

    rvm_gem "nokogiri" do
      ruby_string "jruby-1.5.6"
      version     "1.4.4.2"
      action      :remove
    end

### <a name="lwrps-rvmglobalgem"></a> rvm_global_gem

This resource will use the `rvm_gem` resource to manage a gem in the *global*
gemset accross all RVM Rubies. An entry will also be made/removed in RVM's
*global.gems* file. See the Opscode [package resource][package_resource] and
[gem package options][gem_package_options] pages for more details.

#### <a name="lwrps-rvmglobalgem-actions"></a> Actions

<table>
  <thead>
    <tr>
      <th>Action</th>
      <th>Description</th>
      <th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>install</td>
      <td>
        Install a gem across all Rubies - if version is provided, install that
        specific version.
      </td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>upgrade</td>
      <td>
        Upgrade a gem across all Rubies - if version is provided, upgrade to
        that specific version.
      </td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>remove</td>
      <td>
        Remove a gem across all Rubies.
      </td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>purge</td>
      <td>
        Purge a gem across all Rubies.
      </td>
      <td>&nbsp;</td>
    </tr>
  </tbody>
</table>

#### <a name="lwrps-rvmglobalgem-attributes"></a> Attributes

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>package_name</td>
      <td>
        <b>Name attribute:</b> the name of the gem to install.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>ruby_string</td>
      <td>
        An RVM Ruby string that could contain a gemset. If a gemset is given
        (for example, <code>"ruby-1.8.7-p330@awesome"</code>), then it will
        be used.
      </td>
      <td><code>"default"</code></td>
    </tr>
    <tr>
      <td>version</td>
      <td>
        The specific version of the gem to install/upgrade.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>options</td>
      <td>
        Add additional options to the underlying gem command.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>source</td>
      <td>
        Provide an additional source for gem providers (such as RubyGems).
        This can also include a file system path to a <code>.gem</code> file
        such as <code>/tmp/json-1.5.1.gem</code>.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>user</td>
      <td>
        A users's isolated RVM installation on which to apply an action. The
        default value of <code>nil</code> denotes a system-wide RVM
        installation is being targeted. <b>Note:</b> if specified, the
        user must already exist.
      </td>
      <td><code>nil</code></td>
    </tr>
  </tbody>
</table>

### <a name="lwrps-rvmshell"></a> rvm_shell

This resource is a wrapper for the `script` resource which wraps the code block
in an RVM-aware environment.. See the Opscode
[script resource][script_resource] page for more details.

#### <a name="lwrps-rvmshell-actions"></a> Actions

<table>
  <thead>
    <tr>
      <th>Action</th>
      <th>Description</th>
      <th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>run</td>
      <td>Run the script</td>
      <td>Yes</td>
    </tr>
    <tr>
      <td>nothing</td>
      <td>Do not run this command</td>
      <td>&nbsp;</td>
    </tr>
  </tbody>
</table>

Use `action :nothing` to set a command to only run if another resource
notifies it.

#### <a name="lwrps-rvmshell-attributes"></a> Attributes

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>name</td>
      <td>
        <b>Name attribute:</b> Name of the command to execute.
      </td>
      <td><code>name</code></td>
    </tr>
    <tr>
      <td>ruby_string</td>
      <td>
        An RVM Ruby string that could contain a gemset. If a gemset is given
        (for example, <code>"ruby-1.8.7-p330@awesome"</code>), then it will
        be used.
      </td>
      <td><code>"default"</code></td>
    </tr>
    <tr>
      <td>code</td>
      <td>
        Quoted script of code to execute.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>creates</td>
      <td>
        A file this command creates - if the file exists, the command will not
        be run.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>cwd</td>
      <td>
        Current working director to run the command from.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>environment</td>
      <td>
        A hash of environment variables to set before running this command.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>group</td>
      <td>
        A group or group ID that we should change to before running this command.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>path</td>
      <td>
        An array of paths to use when searching for the command.
      </td>
      <td><code>nil</code>, uses system path</td>
    </tr>
    <tr>
      <td>returns</td>
      <td>
        The return value of the command (may be an array of accepted values) -
        this resource raises an exception if the return value(s) do not match.
      </td>
      <td><code>0</code></td>
    </tr>
    <tr>
      <td>timeout</td>
      <td>
        How many seconds to let the command run before timing out.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>user</td>
      <td>
       A user name or user ID that we should change to before running this command.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>user</td>
      <td>
        A users's isolated RVM installation on which to apply an action. The
        default value of <code>nil</code> denotes a system-wide RVM
        installation is being targeted. <b>Note:</b> if specified, the
        user must already exist.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>umask</td>
      <td>
        Umask for files created by the command.
      </td>
      <td><code>nil</code></td>
    </tr>
  </tbody>
</table>

#### <a name="lwrps-rvmshell-examples"></a> Examples

##### Run A Rake Task

    rvm_shell "migrate_rails_database" do
      ruby_string "1.8.7-p352@webapp"
      user        "deploy"
      group       "deploy"
      cwd         "/srv/webapp/current"
      code        %{rake RAILS_ENV=production db:migrate}
    end

### <a name="lwrps-rvmwrapper"></a> rvm_wrapper

This resource creates a wrapper script for a binary or list of binaries in
a given RVM Ruby (and optional gemset). The given Ruby will be installed if
it isn't already and a gemset will be created in none currently exist.

#### <a name="lwrps-rvmwrapper-actions"></a> Actions

<table>
  <thead>
    <tr>
      <th>Action</th>
      <th>Description</th>
      <th>Default</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>create</td>
      <td>Creates on or more wrapper scripts.</td>
      <td>Yes</td>
    </tr>
  </tbody>
</table>

#### <a name="lwrps-rvmwrapper-attributes"></a> Attributes

<table>
  <thead>
    <tr>
      <th>Attribute</th>
      <th>Description</th>
      <th>Default Value</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>prefix</td>
      <td>
        <b>Name attribute:</b> a prefix string for the wrapper script name.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>ruby_string</td>
      <td>
        An RVM Ruby string that could contain a gemset. If a gemset is given
        (for example, <code>"ruby-1.8.7-p330@awesome"</code>), then it will
        be used.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>binary</td>
      <td>
        A single binary to be wrapped. If this attribute is used do not set
        values for the <code>binaries</code> attribute.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>binaries</td>
      <td>
        A list of binaries to be wrapped. If this attribute is used do not set
        a value for the <code>binary</code> attribute.
      </td>
      <td><code>nil</code></td>
    </tr>
    <tr>
      <td>user</td>
      <td>
        A users's isolated RVM installation on which to apply an action. The
        default value of <code>nil</code> denotes a system-wide RVM
        installation is being targeted. <b>Note:</b> if specified, the user
        must already exist.
      </td>
      <td><code>nil</code></td>
    </tr>
  </tbody>
</table>

**Note:** only `binary` or `binaries` should be used by themselves (never at
the same time).

#### <a name="lwrps-rvmwrapper-examples"></a> Examples

##### Wrapping A Ruby CLI

    rvm_wrapper "sys" do
      ruby_string   "jruby@utils"
      binary        "thor"
    end

This will create a wrapper script called `sys_thor` in the `bin` directory
under `node['rvm']['root_path']`.

##### Wrapping A List Of Binaries

    rvm_wrapper "test" do
      ruby_string   "default@testing"
      binaries      [ "rspec", "cucumber" ]
      action        :create
    end

## <a name="contributing"></a> Contributing

* Source hosted at [GitHub][repo]
* Report issues/Questions/Feature requests on [GitHub Issues][issues]

Pull requests are very welcome! Make sure your patches are well tested.
Ideally create a topic branch for every seperate change you make.

### Testing

Make sure you have the following requirements setup:

* [Vagrant](http://www.vagrantup.com/)
* [vagrant-verkshelf](https://github.com/riotgames/vagrant-berkshelf)

After you `bundle install` run `rake` for unit tests and `kitchen test` for
integration level tests.

## <a name="license"></a> License and Author

Author:: [Fletcher Nichol][fnichol] (<fnichol@nichol.ca>) [![endorse](http://api.coderwall.com/fnichol/endorsecount.png)](http://coderwall.com/fnichol)


Contributors:: https://github.com/fnichol/chef-rvm/contributors

Copyright:: 2010, 2011, Fletcher Nichol

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[berkshelf]:            http://berkshelf.com
[chef_gem_cb]:          http://community.opscode.com/cookbooks/chef_gem
[chef_repo]:            https://github.com/opscode/chef-repo
[cheffile]:             https://github.com/applicationsonline/librarian/blob/master/lib/librarian/chef/templates/Cheffile
[compilation]:          http://wiki.opscode.com/display/chef/Evaluate+and+Run+Resources+at+Compile+Time
[dragons]:              http://en.wikipedia.org/wiki/Here_be_dragons
[gem_package]:          http://wiki.opscode.com/display/chef/Resources#Resources-Package
[gem_package_options]:  http://wiki.opscode.com/display/chef/Resources#Resources-GemPackageOptions
[gh50]:                 https://github.com/fnichol/chef-rvm/issues/50
[fnichol]:              https://github.com/fnichol
[java_cb]:              http://community.opscode.com/cookbooks/java
[jruby]:                http://jruby.org/
[kgc]:                  https://github.com/websterclay/knife-github-cookbooks#readme
[librarian]:            https://github.com/applicationsonline/librarian#readme
[lwrp]:                 http://wiki.opscode.com/display/chef/Lightweight+Resources+and+Providers+%28LWRP%29
[package_resource]:     http://wiki.opscode.com/display/chef/Resources#Resources-Package
[rvm]:                  https://rvm.io
[rvm_create_gemset]:    https://rvm.io/gemsets/creating/
[rvm_delete_gemset]:    https://rvm.io/gemsets/deleting/
[rvm_empty_gemset]:     https://rvm.io/gemsets/emptying/
[rvm_default]:          https://rvm.io/rubies/default/
[rvm_gemsets]:          https://rvm.io/gemsets/
[rvm_install]:          https://rvm.io/rubies/installing/
[rvm_remove]:           https://rvm.io/rubies/removing/
[rvm_upgrading]:        https://rvm.io/rvm/upgrading/
[script_resource]:      http://wiki.opscode.com/display/chef/Resources#Resources-Script
[vagrant]:              http://vagrantup.com

[repo]:         https://github.com/fnichol/chef-rvm
[issues]:       https://github.com/fnichol/chef-rvm/issues
