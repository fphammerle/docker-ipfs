# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.0] - 2022-06-05
### Added
- entrypoint: support changing gateway address & port via environment variable `IPFS_GATEWAY_ADDR`
  (e.g. `IPFS_GATEWAY_ADDR=/ip4/0.0.0.0/tcp/8080` to listen on all ipv4 interfaces)

### Fixed
- docker-compose: remove unsuppported option `volumes[].tmpfs.mode`

## [1.0.0] - 2021-06-20
### Added
- image labels:
  - `org.opencontainers.image.revision` (git commit hash via build arg)
  - `org.opencontainers.image.source` (repo url)
  - `org.opencontainers.image.title`

### Changed
- docker-compose: use custom container name "ipfs" instead of auto-generated "\[PROJECT_NAME\]\_ipfs\_1"
- docker-compose: read-only root filesystem
- docker-compose: drop capabilities

## [0.2.2] - 2020-09-24
### Fixed
- `entrypoint.sh`: restore support for empty `IPFS_SWARM_ADDRS` var

## [0.2.1] - 2020-09-24
### Fixed
- switch from alpine to debian base image to support ipfs >= v0.6.0 (libc incompatibility)

## [0.2.0] - 2019-06-01
### Added
- configure api address via env var `IPFS_API_ADDR`
- `docker-compose.yml`

### Changed
- expose api on `0.0.0.0:5001/tcp` by default
  (`-e IPFS_API_ADDR=default` keeps the previous setting `localhost:5001/tcp`)

## [0.1.1] - 2019-04-21
### Fixed
- `entrypoint.sh`: fixed configuration of bootstrap nodes & swarm addresses
  (failed when ipfs api was unavailable)

## [0.1.0] - 2019-01-05
### Added
- go-ipfs daemon downloaded from https://dist.ipfs.io/go-ipfs/
- configure daemon profile via env var `IPFS_INIT_PROFILE`
- configure swarm listener addresses via env var `IPFS_SWARM_ADDRS`
- add bootstrap nodes via env var `IPFS_BOOTSTRAP_ADD`

[Unreleased]: https://github.com/fphammerle/docker-ipfs/compare/1.1.0...HEAD
[1.1.0]: https://github.com/fphammerle/docker-ipfs/compare/1.0.0...1.1.0
[1.0.0]: https://github.com/fphammerle/docker-ipfs/compare/0.2.2...1.0.0
[0.2.2]: https://github.com/fphammerle/docker-ipfs/compare/0.2.1...0.2.2
[0.2.1]: https://github.com/fphammerle/docker-ipfs/compare/0.2.0...0.2.1
[0.2.0]: https://github.com/fphammerle/docker-ipfs/compare/0.1.1...0.2.0
[0.1.1]: https://github.com/fphammerle/docker-ipfs/compare/0.1.0...0.1.1
[0.1.0]: https://github.com/fphammerle/docker-ipfs/tree/0.1.0
