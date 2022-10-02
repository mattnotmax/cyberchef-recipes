git Cookbook CHANGELOG
======================
This file is used to list changes made in each version of the git cookbook.


v2.7.0
------
### Bug
- **[COOK-3624](https://tickets.opscode.com/browse/COOK-3624)** - Don't restart `xinetd` on each Chef client run
- **[COOK-3482](https://tickets.opscode.com/browse/COOK-3482)** - Force git to add itself to the current process' PATH

### New Feature
- **[COOK-3223](https://tickets.opscode.com/browse/COOK-3223)** - Support Omnios and SmartOS package installs

v2.6.0
------
### Improvement
- **[COOK-3193](https://tickets.opscode.com/browse/COOK-3193)** - Add proper debian packages

v2.5.2
------
### Bug
- [COOK-2813]: Fix bad string interpolation in source recipe

v2.5.0
------
- Relax runit version constraint (now depend on 1.0+).

v2.4.0
------
- [COOK-2734] - update git versions

v2.3.0
------
- [COOK-2385] - update git::server for `runit_service` resource support

v2.2.0
------
- [COOK-2303] - git::server support for RHEL `platform_family`

v2.1.4
------
- [COOK-2110] - initial test-kitchen support (only available in GitHub repository)
- [COOK-2253] - pin runit dependency

v2.1.2
------
- [COOK-2043] - install git on ubuntu 12.04 not git-core

v2.1.0
------
The repository didn't have pushed commits, and so the following changes from earlier-than-latest versions wouldn't be available on the community site. We're releasing 2.1.0 to correct this.

- [COOK-1943] - Update to git 1.8.0
- [COOK-2020] - Add setup option attributes to Git Windows package install

v2.0.0
-------
This version uses `platform_family` attribute, making the cookbook incompatible with older versions of Chef/Ohai, hence the major version bump.

- [COOK-1668] - git cookbook fails to run due to bad `platform_family` call
- [COOK-1759] - git::source needs additional package for rhel `platform_family`

v1.1.2
------
- [COOK-2020] - Add setup option attributes to Git Windows package install

v1.1.0
------
- [COOK-1943] - Update to git 1.8.0

v1.0.2
------
- [COOK-1537] - add recipe for source installation

v1.0.0
------
- [COOK-1152] - Add support for Mac OS X
- [COOK-1112] - Add support for Windows

v0.10.0
-------
- [COOK-853] - Git client installation on CentOS

v0.9.0
------
- Current public release
