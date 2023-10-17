# Changelog
All notable changes to this module will be documented in this file.
 
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this module adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
 
## [Unreleased 

## [2.0.0] - 2023-10-17

Complete rewrite of the module. It now deploys a runbook to dynamically create the required update schedules based on the used tags. Furthermore it uses the new severity group structure. 

To use the new version, remove all previous module calls and create **only one** call of the new module. Furthermore upgrade all tags from the old severity group structure to the new one. You can monitor the usage of wrong text in the output of the runbook.
 
### Added
 
- automation runbook that automatically creates and updates update deployment groups
 
### Changed

- dependecy: use new severity group syntax
 
### Removed

- update schedule deployment arm templates for linux and windows

### Fixed