if [ -f /var/log/install_puppet.done ]
then
  echo "Puppet already installed"
else
  #
  # Install correct puppet version
  #
  if [ -f "/vagrant/puppet_version" ]; then
    PACKAGE="puppet-agent-$(cat /vagrant/puppet_version)"
  else
    PACKAGE="puppet-agent"
  fi
  echo "Installing $PACKAGE"
  rhel=$(rpm -q --queryformat '%{RELEASE}' rpm | grep -o [[:digit:]]*\$)
  yum install -y --nogpgcheck https://yum.puppetlabs.com/puppet6/puppet6-release-el-${rhel}.noarch.rpm > /dev/null
  yum install -y --nogpgcheck $PACKAGE
  rpm -q git || yum install -y --nogpgcheck git

  touch /var/log/install_puppet.done
fi