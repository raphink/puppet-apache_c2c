define apache_c2c::redhat::selinux {

  case $name {

    'cgi': {
      selboolean { 'httpd_enable_cgi':
        value      => 'on',
        persistent => true,
      }
    }

    'userdir': {
      selboolean { 'httpd_enable_homedirs':
        value      => 'on',
        persistent => true,
      }
    }

    'proxy', 'rewrite', 'ldap', 'shib': {
      if defined(Selboolean['httpd_can_network_connect']) { }
      else {
        # or httpd_can_network_relay ??
        selboolean { 'httpd_can_network_connect':
          value      => 'on',
          persistent => true,
        }
      }
    }

    'php', 'php4', 'php5', 'perl', 'wsgi', 'python': {
      if defined(Selboolean['httpd_builtin_scripting']) { }
      else {
        selboolean { [
          'httpd_builtin_scripting',
          'httpd_can_network_connect_db',
        ]:
          value      => 'on',
          persistent => true,
        }
      }
    }

    'suexec': {
      if versioncmp($::operatingsystemmajrelease, '6') < 0 {
        selboolean { 'httpd_suexec_disable_trans':
          value      => 'off',
          persistent => true,
        }
      }
    }

    'include': {
      selboolean { 'httpd_ssi_exec':
        value      => 'on',
        persistent => true,
      }
    }

    default: {}

  }
}
