Exec { path => "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"}

# Global variables
$user = $::default_user
$password = "1234"
$project = $::project_name
$python_project_dir = "/home/${user}/${project}/backend"
$node_project_dir = "/home/${user}/${project}/frontend"


stage { 'pre':
  before => Stage["main"],
}

class apt-update{
  exec {'apt-update':
    command => "sudo apt-get update"
  }
}
class {'apt-update':
   stage => 'pre'
}


class { 'apt': }

include user

class user {
  exec { "add user":
    command => "sudo useradd -m -G sudo -s /bin/bash ${user}",
    unless  => "id -u ${user}"
  }
  exec { "set password":
    command => "echo \'${user}:${password}\' | sudo chpasswd",
    require => Exec["add user"]
  }
  file { ["/home/${user}/${project}"]:
    ensure  => directory,
    owner   => "${user}",
    group   => "${user}",
    require => Exec['add user']
  }
}

include gcc

# python install

include python-req-deps

class python-req-deps {  
  package { 'libpq-dev':
  ensure  => latest,
  require => Class["apt"]
  }
}

class { 'python' :
  version    => '3.4',
  pip        => true,
  dev        => true,
  virtualenv => true,
  gunicorn   => false,
  require    => Class["python-req-deps"]
}

python::virtualenv { 'venv python3' :
  ensure       => present,
  version      => '3.4',
  requirements => "${python_project_dir}/requirements.txt",
  venv_dir     => "/home/vagrant/venvs",
  owner        => $user,
  group        => $user,
  cwd          => "${python_project_dir}",
  virtualenv   => "virtualenv",
}

# postgresql install
class { 'postgresql::server':
  ip_mask_deny_postgres_user => '0.0.0.0/32',
  ip_mask_allow_all_users    => '0.0.0.0/0',
  listen_addresses           => '*',
  postgres_password          => 'pass'
}

postgresql::server::db { 'django_db':
  user     => 'django_db',
  password => postgresql_password('django_db', 'whynot'),
}

# redis install
class { 'redis': }

# Nginx

include ::nginx
include ::nginx::config

# nodejs

include nodejs-deps

class { 'nodejs':
  version => 'stable',
  make_install => false
}

class nodejs-deps{
  # Install global npm packages.  Update npm last.
  package { 'npm':
    ensure   => '2.9.0',
    provider => 'npm',
    require  => Class['nodejs'],
  }

  package { 'npm-check-updates':
    ensure   => '1.5.1',
    notify   => Package['npm'],
    provider => 'npm',
    require  => Class['nodejs'],
  }

  package {'nodejs-legacy':
    ensure    => latest,
  }

  package {'webpack':
    ensure   => present,
    provider => 'npm',
    require  => [Package['npm'], Package['nodejs-legacy']],
  }

  exec { "installing deps":
    command => 'npm install --no-bin-links',
    cwd     => "${node_project_dir}",
    path    => '/usr/local/node/node-default/bin/',
    require => Package['npm']
  }

  # Allow vagrant user to global install npm packages
  exec { 'chown node directory':
    command => '/bin/chown -R vagrant:vagrant /usr/local/node/',
    path    => '/bin',
    require => Package['npm'],
    user    => 'root',
  }

}

include software

class software {
  package { "git":
    ensure  => latest,
    require => Class["apt"]
  }
  package { "htop":
    ensure  => latest,
    require => Class["apt"]
  }
}

