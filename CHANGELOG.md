# Changelog
All notable changes to this module will be documented in this file.
 
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this module adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
 
## [Unreleased]

## [3.0.1] - 2025-10-20

### Fixed 
- Ignore all changes on NoMaintenance maintenance configuration to prevent issues with start/endtime on resource updates.

## [3.0.0] - 2025-08-26

### Added
- added maintenance configuration "NoMaintenance" 
- runbook that remediates the main update management policies twice a day

### Changed 
- main functionality of the entire module 

## [2.0.3] - 2024-05-10

### Fixed

- Fixed issue that all schedules were created with a start date after the planned date

## [2.0.2] - 2024-02-19

### Fixed

- Fixed wrong variable name in azure query creation
- fixed typo in regex
- added errorCounter to actualle let the runbook status be "failed" if error occur

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