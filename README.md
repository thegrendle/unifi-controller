# unifi-controller
Containerized Ubiquiti Networks Unifi Controller.

To build the containerized Unifi Controller:

  $ git clone git@github.com:thegrendle/unifi-controller.git

  $ cd unifi-controller.git

  $ podman build -t unifi-controller:<version> .

To run the containerized Unifi Controller:

  1. Run the container:

      $ podman run -d \
        -p 6789:6789/tcp \
        -p 8080:8080/tcp \
        -p 8443:8443/tcp \
        -p 8843:8843/tcp \
        -p 8880:8880/tcp \
        -p 1900:1900/udp \
        -p 3478:3478/udp \
        -p 5353:5353/udp \
        -p 10001:10001/udp \
        unifi-controller:7.3.83-latest

  2. If you are running a distro with firewalld, you can use the
     unifi.xml file.

      $ sudo cp unifi.xml /etc/firewalld/services
      $ sudo restorecon -rFv /etc/firewalld/services/*
      $ firewall-cmd --zone=<zone> --add-service=unifi --permanent
      $ firewall-cmd --reload

This container is not associated with or built by anyone associated 
with Ubiquiti Networks.  I just really wanted a containerized
version of this.
