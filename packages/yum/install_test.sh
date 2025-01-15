#!/bin/bash

set -exu

package="$1"

os_version=$(cut -d: -f5 /etc/system-release-cpe)

case "${os_version}" in
  8)
    DNF_INSTALL="dnf install -y --enablerepo=powertools"
    sudo dnf module -y disable mysql
    ;;
  *)
    DNF_INSTALL="dnf install -y"
    sudo ${DNF_INSTALL} "https://apache.jfrog.io/artifactory/arrow/almalinux/${os_version}/apache-arrow-release-latest.rpm"
    ;;
esac

sudo ${DNF_INSTALL} "https://packages.groonga.org/almalinux/${os_version}/groonga-release-latest.noarch.rpm"

case "${package}" in
  mariadb-*)
    mariadb_version=$(echo "${package}" | cut -d'-' -f2)
    service_name=mariadb
    have_auto_generated_password="no"

    cat <<REPO | sudo tee /etc/yum.repos.d/MariaDB.repo
[mariadb]
name = MariaDB
baseurl = "https://rpm.mariadb.org/${mariadb_version}/rhel/\$releasever/\$basearch"
gpgkey = https://rpm.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck = 1
REPO
    sudo dnf module -y disable mariadb
    ;;
  mysql-community-*)
    mysql_version=$(echo "${package}" | cut -d'-' -f3)
    mysql_package_version=$(echo "${mysql_version}" | sed -e 's/\.//g')
    service_name=mysqld
    have_auto_generated_password="yes"

    sudo ${DNF_INSTALL} \
         "https://repo.mysql.com/mysql${mysql_package_version}-community-release-el${os_version}.rpm"
esac

sudo ${DNF_INSTALL} "${package}"
sudo systemctl start "${service_name}"
mysql="mysql -u root"
if [ "${have_auto_generated_password}" = "yes" ]; then
  auto_generated_password=$(sudo awk '/root@localhost/{print $NF}' /var/log/mysqld.log | tail -n 1)
  mysql="mysql -u root -p${auto_generated_password}"
  sudo ${mysql} --connect-expired-password -e "ALTER USER user() IDENTIFIED BY '$auto_generated_password'"
fi

sudo ${mysql} -e "SHOW ENGINES" | grep Mroonga
