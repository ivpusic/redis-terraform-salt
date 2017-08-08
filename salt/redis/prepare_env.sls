redis_user:
  user.present:
    - name: redis
    - gid_from_name: True

/etc/redis:
  file.directory:
    - user: root
    - group: root

/var/lib/redis:
  file.directory:
    - user: redis
    - group: redis

/etc/systemd/system/redis.service:
  file.managed:
    - source: salt://redis/files/redis.service
    - user: root
    - group: root

/etc/redis/redis.conf:
  file.managed:
    - source: salt://redis/files/redis.conf
    - user: root
    - group: root

/var/log/redis.log:
  file.managed:
    - user: redis
    - group: redis
