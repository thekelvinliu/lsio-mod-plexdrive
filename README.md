# lsio-mod-plexdrive

add [plexdrive] to a linuxserver docker container to mount google drive as a read-only filesystem

## usage

this docker mod requires fuse, meaning docker containers must be privileged and have access to `/dev/fuse` on the host.
for example with docker compose:

```yaml
---
services:
  jellyfin:
    image: lscr.io/linuxserver/jellyfin:latest
    environment:
      DOCKER_MODS: "thekelvinliu/lsio-mod-plexdrive:latest"
      PUID: 1000
      PGID: 1000
    privileged: true
    devices:
      - /dev/fuse:/dev/fuse
    volumes:
      - ./config/jellyfin:/config
      - ./config/plexdrive:/plexdrive
```

## configuration

this docker mod does not handle the initial plexdrive authentication with google drive.
it's best to do this setup elsewhere and copy the resulting `config.json` and `token.json` files into a docker volume,
which can then be mounted as the config directory for plexdrive (`/plexdrive` or the value of `PLEXDRIVE_CONFIG_DIR`).

after setup, the default directory should look something like this:

```
/plexdrive
├── config.json
└── token.json
```

### environment variables

every environment variable and its default value if there is one is listed below:

- `PLEXDRIVE_CACHE_FILE`: path to plexdrive cache file (default: `/plexdrive/cache.bolt`)
- `PLEXDRIVE_CONFIG_DIR`: path to plexdrive config directory (default: `/plexdrive`)
- `PLEXDRIVE_MOUNT_DIR`: path to plexdrive mount directory (default: `/mnt/plexdrive`)
- `PLEXDRIVE_ROOT_NODE_ID`: google drive node id for plexdrive to mount

[plexdrive]: https://github.com/plexdrive/plexdrive
