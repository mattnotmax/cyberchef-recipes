## v1.3.0
  * update default versions to the latest: node - v0.10.15 and npm - v1.3.5
  * default to package installation of nodejs on smartos ([@wanelo-pair][])
  * Add Raspberry pi support ([@robertkowalski][])

## v1.2.0
  * implement installation from package on RedHat - ([@vaskas][])

## v1.1.3:
  * update default version of node to 0.10.13 - and npm - v1.3.4 ([@jodosha][])

## v1.1.2:
  * update default version of node to 0.10.2 - ([@bakins][])
  * fully migrated to test-kitchen 1.alpha and vagrant 1.1.x/berkshelf 1.3.1

## v1.1.1:
  * update default versions to the latest: node - v0.10.0 and npm - v1.2.14
  * `make_thread` is now a real attribute - ([@ChrisLundquist][])


## v1.1.0:
  * rewrite the package install; remove rpm support since there are no longer any packages available anywhere
  * add support to install `legacy_packages` from ubuntu repo as well as the latest 0.10.x branch (this is default).

## v1.0.4:
  * add support for binary installation method ([@JulesAU][])

## v1.0.3:
  - unreleased

## v1.0.2:
  * add smartos support for package install ([@sax][])
  * support to compile with all processors available (default 2 if unknown) - ([@ChrisLundquist][])
  * moved to `platform_family` syntax
  * ensure npm recipe honours the 'source' or 'package' setting - ([@markbirbeck][])
  * updated the default versions to the latest stable node/npm

## v1.0.1:

 * fixed bug that prevented overwritting the node/npm versions (moved the `src_url`s as local variables instead of attributes) - ([@johannesbecker][])
 * updated the default versions to the latest node/npm

## v1.0.0:

* added packages installation support ([@smith][])

[@JulesAU]: https://github.com/JulesAU
[@sax]: https://github.com/sax
[@ChrisLundquist]: https://github.com/ChrisLundquist
[@markbirbeck]: https://github.com/markbirbeck
[@johannesbecker]: https://github.com/johannesbecker
[@smith]: https://github.com/smith
[@bakins]: https://github.com/bakins
[@vaskas]: https://github.com/vaskas
[@robertkowalski]: https://github.com/robertkowalski
[@wanelo-pair]: https://github.com/wanelo-pair
