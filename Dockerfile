# Talos system extension: devmapper-pool (ADR-038)
# Creates dm-thin-pool at boot for containerd devmapper snapshotter

FROM --platform=linux/amd64 alpine:3.21 AS tools
RUN apk add --no-cache busybox-static util-linux

FROM scratch
COPY manifest.yaml /manifest.yaml
COPY devmapper-pool.yaml /rootfs/usr/local/etc/containers/devmapper-pool.yaml

# busybox-static includes: sh, dd, readlink, mkdir, cat, kill, losetup, blockdev, nsenter, grep, tr, ls, sleep

# CRI config shipped as static file — installed into Talos rootfs at build time.
# CRI reads /etc/cri/conf.d/ on startup. If extension creates the pool (~500ms)
# BEFORE CRI initializes devmapper plugin (~2-3s), devmapper loads on first boot.
# If CRI starts first: devmapper plugin fails gracefully (disabled), runc works.
# Extension also writes config to overlay dir as fallback for next CRI restart.
COPY 20-devmapper.part /rootfs/usr/local/etc/cri/conf.d/20-devmapper.part

# Extension service: creates thin pool at boot
COPY --from=tools /bin/busybox.static /rootfs/usr/local/lib/containers/devmapper-pool/bin/busybox
# Full nsenter from util-linux (legacy, kept for diagnostics)
COPY --from=tools /usr/bin/nsenter /rootfs/usr/local/lib/containers/devmapper-pool/bin/nsenter
# reboot from util-linux — uses reboot(2) syscall which is global (works from any namespace)
COPY --from=tools /sbin/reboot /rootfs/usr/local/lib/containers/devmapper-pool/bin/reboot
COPY devmapper-pool-init /rootfs/usr/local/lib/containers/devmapper-pool/devmapper-pool-init
