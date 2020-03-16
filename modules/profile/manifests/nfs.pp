# profile::nfs
#
# Configure NFS storage
#
# @summary A short summary of the purpose of this class
#
# @example
#   include profile::nfs
class profile::nfs(
  Array[Stdlib::Absolutepath]
            $nfs_files,
  Stdlib::Absolutepath
            $nfs_mountpoint,
  Stdlib::Absolutepath
            $nfs_export,
) inherits ora_profile::database {

  file { $nfs_export:
    ensure  => directory,
    recurse => false,
    replace => false,
    mode    => '0775',
    owner   => $grid_user,
    group   => $grid_admingroup,
  }

  $nfs_files.each |$file| {
    exec { "/bin/dd if=/dev/zero of=${file} bs=1 count=0 seek=7520M":
      user      => $grid_user,
      group     => $grid_admingroup,
      logoutput => true,
      unless    => "/usr/bin/test -f ${file}",
    }

    -> file { $file:
      ensure => present,
      owner  => $grid_user,
      group  => $grid_admingroup,
      mode   => '0664',
    }
  }

  contain ::nfs

  nfs::server::export{ $nfs_export:
    ensure      => 'mounted',
    options_nfs => 'rw sync no_wdelay insecure_locks no_root_squash',
    clients     => "${facts['fqdn']}(rw,insecure,async,no_root_squash) localhost(rw)",
  }
}
