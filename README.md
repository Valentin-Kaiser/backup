# Backup - Docker Container

This container is used to backup your data to a [restic](https://restic.net/) repository.

## Usage

Pull the docker image from the [GitHub Container Registry](ghcr.io)

`docker pull ghcr.io/valentin-kaiser/backup:latest`

Run the container with the following command or use [docker compose](./compose.yml)


```bash
docker run -d \
  -e CRON_SCHEDULE="0 0 * * *" \
  -e RESTIC_REPOSITORY="/backup" \
  -v /path/to/backup:/source \
  -v /path/to/restic/repository:/backup \
  ghcr.io/valentin-kaiser/backup:latest
```

### Volumes and secrets
 
- `/source`: The source directory to backup
- `/backup`: The target directory to backup to a restic local repository
- `/run/secrets/restic_password`: The password file for the restic repository

### Configuration via environment variables

The container schedules the backup and forget scripts using cron.
Your data should be mounted to `/source` and your backup to `/backup`, but Restic can backup to different [types of repositories](https://restic.readthedocs.io/en/latest/030_preparing_a_new_repo.html).
Possible values are `local`, `sftp`, `rest`, `s3`, `gs`, `b2`, `azure`, `rclone`. 
Per default the container uses a local repository. You should mount the repository to `/backup` or configure it using environment variables.
To secure your backup you should use docker secrets/a password file. The password file should be mounted to `/run/secrets/restic_password`.

> You can fine tune restic and the backup and forget commands using the following environment variables and [restic environment variables](https://restic.readthedocs.io/en/latest/040_backup.html#environment-variables).
 
- `BACKUP_SCHEDULE`: The schedule for the backup. Default: `0 0 * * *`
- `FORGET_SCHEDULE`: The schedule for the forget command. Default: `0 1 * * 7`
- `RESTIC_SOURCE`: The source directory to backup. Default: `/source`
- `RESTIC_REPOSITORY`: The backup repository. Default local directory: `/backup`
- `RESTIC_PASSWORD_FILE`: The password file for the restic repository. Default: `/run/secrets/restic_password`
- `RESTIC_BACKUP_ARGS`: The arguments for the backup command. Default: `--exclude-caches --exclude-if-present=.nobackup --exclude-if-present=.backupignore`
- `RESTIC_FORGET_ARGS`: The arguments for the forget command. Default: `--prune --keep-daily 7 --keep-weekly 4 --keep-monthly 6`
- `RESTIC_COMMPRESSION`: The compression algorithm to use. Default: `auto`

### Scripts

The container ships with four scripts:

- [`/entrypoint.sh`](./scripts/entrypoint.sh): The entrypoint script ensures that the restic repository is initialized and the cron job is scheduled and daemon started
- [`/backup.sh`](./scripts/backup.sh): The backup script runs the restic backup command and will be scheduled by cron to create new backups
- [`/forget.sh`](./scripts/forget.sh): The forget script runs the restic forget command and will be scheduled by cron to prune old backups
- [`/restore.sh`](./scripts/restore.sh): The restore script leads you through the restore process

### Logging

The container logs to three different log files that can be found in `/var/log`:

- `/var/log/backup.log`: The output of the backup command
- `/var/log/forget.log`: The output of the forget command