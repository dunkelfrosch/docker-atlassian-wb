# ChangeLog of Docker Atlassian Workbench 1.0.3

All notable changes of the Docker Atlassian Workbench release series are documented in this file using the [Keep a CHANGELOG](http://keepachangelog.com/) principles.

_This Docker Atlassian Workbench changeLog documentation start with version 1.0.0 (2015-12-30)_

## [1.0.3], 2016-03-27:
_current_

### Fixed

* fix image naming issues and minor internal comment/doc related points
* fix wording/spelling in documentation

### Added

* new compose relation mapping using service related sub compose files
* mysql config lines for innodb log/package size for jira
* missing 'sysstat' and 'ntp' package to needful images
* external cleanup script source

### Removed

* obsolete parts of our documentation
* old sub compose files for service and data-container's
* old ENV setup inside mysql service container
* old local cleanup script

### Changed

* change/extend current documentation
* base host/container cpu/memory config
* upgrade nginx to version 1.9.9
* upgrade mysql to version 5.7.n in jira db container

## [1.0.2], 2016-03-07:

### Fixed

* fix timestamp issue in changelog
* fix minor documentation issues
* fix network issue in docker-compose-file

### Added

* sample cpu payload for our services

## [1.0.1], 2016-01-30:

### Added

* container backup scripts for local and dropbox storage
* networking bridge composer configuration

### Removed

* deprecated link bound for each container
* old application single docker-compose config

### Changed

* maintenance scripts naming

### Fixed

* ssl-config in nginx proxy container

## [1.0.0], 2015-12-30:

### Added
initial commit