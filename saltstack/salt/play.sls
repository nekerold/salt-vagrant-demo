install_network_packages:
  pkg.installed:
    - pkgs:
      - rsync
      - lftp
      - curl
      - mysql-server
      - vsftpd
      - openssl

create app_directory:
 file.directory:
   - name: /opt/app
   - user: root
   - group: root
   - mode: 755

x509_signing_policies:
  www:
    - minions: '*'
    - signing_private_key: /etc/pki/ca.key
    - signing_cert: /etc/pki/ca.crt
    - C: US
    - ST: Utah
    - L: Salt Lake City
    - basicConstraints: "critical CA:false"
    - keyUsage: "critical cRLSign, keyCertSign"
    - subjectKeyIdentifier: hash
    - authorityKeyIdentifier: keyid,issuer:always
    - days_valid: 90
    - copypath: /etc/pki/issued_certs/

Make sure the mysql service is running:
  service.running:
    - name: mysql

Make sure the mysql service is running and enable it to start at boot:
  service.running:
    - name: mysql
    - enable: True

Make sure the vsftp service is running and enable it to start at boot:
  service.running:
    - name: vsftpd
    - enable: True

Clone the SaltStack bootstrap script repo:
  pkg.installed:
    - name: git # make sure git is installed first!
  git.latest:
    - name: https://github.com/saltstack/salt-bootstrap
    - rev: develop
    - target: /tmp/salt

user account for pete:
  user.present:
    - name: nick
    - shell: /bin/bash
    - home: /home/nick
    - groups:
      - sudo

myserver in hosts file:
  host.present:
    - name: myserver
    - ip: 192.168.0.42

restart vsftpd:
  module.run:
    - name: service.restart
    - m_name: vsftpd  # m_name gets passed to the execution module as "name"
