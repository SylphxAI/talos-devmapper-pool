# talos-devmapper-pool

`talos-devmapper-pool` is an active integration repository for a Talos system
extension that creates and configures a containerd devmapper thin pool at boot.
It owns the extension image inputs, boot service manifest, CRI devmapper
configuration, and init script needed by consumers that deliberately choose this
snapshotter path.

## Lifecycle And Layer

- Lifecycle: `active`
- Layer: `integration`

## Goals

- Package a Talos system extension that creates the `containerd-pool` dm-thin
  pool from the documented node partition.
- Install CRI configuration for containerd devmapper and Kata runtime usage
  through explicit extension files.
- Keep reboot, boot ordering, and recovery assumptions visible in this repo's
  extension source.

## Non-Goals

- Own Talos Linux, containerd, dm-thin, Kata Containers, or host partition
  provisioning outside this extension.
- Own custom Talos image composition, cluster rollout policy, or downstream node
  upgrade orchestration.
- Publish enterprise doctrine, org rulesets, or shared CI/release policy.

## Boundaries

This repository owns only the devmapper-pool extension artifact and its boot-time
behavior. Consumers must depend on the published extension image and documented
files, not on hidden cluster assumptions. Node partition creation, Talos image
selection, and cluster rollout safety belong to downstream infrastructure.

## Public Surfaces

- `Dockerfile` defines the extension image.
- `manifest.yaml` defines Talos extension metadata and compatibility.
- `devmapper-pool.yaml` defines the Talos extension service.
- `20-devmapper.part` defines containerd CRI devmapper and Kata runtime config.
- `devmapper-pool-init` implements boot-time pool creation and reboot behavior.
- `.github/workflows/build.yml` publishes the GHCR extension image on main/tag
  pushes.
- `.doctrine/project.json` is the machine-readable project manifest.

## Delivery

Main and tag pushes build and publish the extension image. Pull-request
admission is not yet declared in this repository. Production proof for behavior
changes must include build evidence, image readback, and Talos boot/runtime
evidence on an affected node or rehearsal environment.

The authoritative control-plane record is `.doctrine/project.json`.
