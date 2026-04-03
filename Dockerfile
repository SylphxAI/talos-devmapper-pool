# Talos system extension: devmapper-pool (ADR-038)
# Creates dm-thin-pool at boot for containerd devmapper snapshotter

FROM --platform=linux/amd64 alpine:3.21 AS tools
RUN apk add --no-cache busybox-static

FROM scratch
COPY manifest.yaml /manifest.yaml
COPY devmapper-pool.yaml /rootfs/usr/local/etc/containers/devmapper-pool.yaml

# busybox-static includes: sh, dd, readlink, mkdir, cat, kill, losetup, blockdev, nsenter, grep, tr, ls, sleep
COPY --from=tools /bin/busybox.static /rootfs/usr/local/lib/containers/devmapper-pool/bin/busybox
COPY devmapper-pool-init /rootfs/usr/local/lib/containers/devmapper-pool/devmapper-pool-init
