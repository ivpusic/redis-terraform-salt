service.systemctl_reload:
  module.run:
    - onchanges:
      - file: /etc/systemd/system/redis.service

redis.service:
  pkg.purged: []
  service.running:
    - watch:
      - file: /etc/systemd/system/redis.service
      - redis_user
    - failhard: True
