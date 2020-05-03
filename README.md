# Ubiquiti Networks Unifi Controller

[![Docker Repository on Quay](https://quay.io/repository/xguitian/unifi/status "Docker Repository on Quay")](https://quay.io/repository/xguitian/unifi)

This is a repo for building and running a Fedora based container for the Ubiquiti Networks Unifi Controller with [Podman](https://github.com/containers/libpod).

- **Version:** 5.12.66
- **SHA256:** 04c6dfafeeb26e80831e06a630132b3dae06d63fe44a9e318148dbe1eae5d21f 
- **Unifi Forum URL:** https://community.ui.com/releases/UniFi-Network-Controller-5-12-66/ac49e57b-6f38-4912-8455-940d3d487d00

_You need to register for the beta forums to access the above Unifi Forum URL._

### Prerequisites

```
sudo dnf install podman git -y
sudo adduser -r -s /sbin/nologin -d /opt/unifi -u 271 -U unifi
sudo mkdir -p /opt/unifi/{data,logs,run}
sudo chown -R unifi. /opt/unifi
sudo chcon -Rt svirt_sandbox_file_t /opt/unifi/
sudo firewall-cmd --zone=$(firewall-cmd --get-default-zone) --add-port=3478/udp --add-port=8080/tcp --add-port=8443/tcp --add-port=8843/tcp --add-port=10001/udp
sudo firewall-cmd --runtime-to-permanent
```

### Quick Start

```
sudo podman run -d --cap-drop ALL \
  -e UNIFI_UID=$(id -u unifi) \
  -e JVM_MAX_HEAP_SIZE=1024m \
  -e TZ='America/Chicago' \
  -p 3478:3478/udp -p 8080:8080/tcp -p 8443:8443/tcp -p 8843:8843/tcp -p 10001:10001/udp \
  -v /opt/unifi/data:/opt/unifi/data:Z \
  -v /opt/unifi/logs:/opt/unifi/logs:Z \
  -v /opt/unifi/run:/opt/unifi/run:Z \
  --name unifi quay.io/xguitian/unifi:5.12.66
```

### Build From GitHub

```
sudo podman build --build-arg UNIFI_VERSION=5.12.66 \
    --build-arg UNIFI_SHA256=0d6a68f71e5c83f33ee89dc95279487ad505c0119b5c7166bbf7431b1a0b7fe9 \
    --build-arg UNIFI_UID=$(id -u unifi) \
    -t unifi:5.12.66 git://github.com/xguitian/unifi
```

### Build Locally

```
git clone https://github.com/xguitian/unifi
cd unifi
sudo podman build --build-arg UNIFI_VERSION=5.12.66 \
    --build-arg UNIFI_SHA256=0d6a68f71e5c83f33ee89dc95279487ad505c0119b5c7166bbf7431b1a0b7fe9 \
    --build-arg UNIFI_UID=$(id -u unifi) \
    -t unifi:5.12.66 .
```

### Run the Ubiquiti Networks Unifi Controller

```
sudo podman run -d --cap-drop ALL -e UNIFI_UID=$(id -u unifi) \
  -e UNIFI_VERSION=5.12.66 \
  -e JVM_MAX_HEAP_SIZE=1024m \
  -e TZ='America/Chicago' \
  -p 3478:3478/udp -p 8080:8080/tcp -p 8443:8443/tcp -p 8843:8843/tcp -p 10001:10001/udp \
  -v /opt/unifi/data:/opt/unifi/data:Z \
  -v /opt/unifi/logs:/opt/unifi/logs:Z \
  -v /opt/unifi/run:/opt/unifi/run:Z \
  --name unifi localhost/unifi:5.12.66
```

## License

The MIT License

Copyright (c) 2019 Joe Doss

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
