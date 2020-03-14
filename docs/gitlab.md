https://docs.gitlab.com/runner/install/linux-repository.html

/etc/gitlab-runner/config.toml

```shell
concurrent = 3
check_interval = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "fastvps"
  url = "https://gitlab.com"
  token = "3DLkaP755_F5vkZoqjT3"
  executor = "docker"
  environment = ["DOCKER_TLS_CERTDIR="]
  [runners.custom_build_dir]
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]
  [runners.docker]
    tls_verify = false
    image = "alpine:latest"
    privileged = true
    disable_entrypoint_overwrite = false
    oom_kill_disable = false
    disable_cache = false
    volumes = ["/cache"]
    shm_size = 0
```

`ssh-keygen -t rsa -b 4096`
Copy content of `~/.ssh/id_rsa` to `$SSH_PRIVATE_KEY` in Gitlab Settings -> Ci / CD -> Variables
Add content of `~/.ssh/id_rsa.pub` to `~/.ssh/authorized_keys` on the server
Copy content of `ssh-keyscan -H nv6.ru` to `$SSH_KNOWN_HOSTS` in Gitlab Settins

/etc/ssh/ssd_config
```
AllowTcpForwarding yes
GatewayPorts yes
MaxSessions 100
```
