These should get dropped into /etc/systemd/system/ and enabled.

For some reason, systemd wont handle templated mount units (export@.mount), and will not resolve %i in the mount units. This is totally lame. Hopefully once this is fixed I can just use this:

    [Unit]
    Description=Bind mount %i
    DefaultDependencies=no
    Conflicts=umount.target shutdown.target
    Before=local-fs.target umount.target
    Requires=zfs.service
    After=zfs.service
    ConditionPathIsMountPoint=/data/%i

    [Mount]
    What=/data/%i
    Where=/export/%i
    Type=none
    Options=bind

    [Install]
    WantedBy=local-fs.target

## BTsync

Overrides to unit files are parsed from ```/etc/systemd/system/UNIT.d/*.conf```. You can see overrides with ```systemd-delta``` or ```systemctl cat myservice.service```.
