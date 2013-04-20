# = Class: locales
#
# This is the main locales class
#
#
# == Parameters
#
# [*locales*]
#   Array with the locales and charsets you want to be created.
#   Example: [ 'en_US.UTF-8 UTF-8', 'another_locale another_charset' ]
#   Default: empty, so just installs the package and leave the locales configured
#   to distro-specific defaults
#   NOTE: CentOS (and probably other RedHat-based distros) don't have a locales package
#   and just set the value in a config file so, in case puppet detects a RH-based distro,
#   it will just take the first value of the first string and use it to set this parameter.
#   Due to this, if you want all your systems configured with the same locale, the first
#   value is the one that will propagate to all the distros.
#
# [*generate_command*]
#   Command to generate locale files.
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, locales class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $locales_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, locales main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $locales_source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, locales main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $locales_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $locales_options
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $locales_absent
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $locales_audit_only
#   and $audit_only
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: false
#
# Default class params - As defined in locales::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of locales package
#
# [*config_dir*]
#   Main configuration directory. Used by puppi
#
# [*config_file*]
#   Main configuration file path
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include locales"
# - Call locales as a parametrized class
#
# See README for details.
#
#
class locales (
  $my_class            = params_lookup( 'my_class' ),
  $locales             = params_lookup( 'locales' ),
  $source              = params_lookup( 'source' ),
  $template            = params_lookup( 'template' ),
  $options             = params_lookup( 'options' ),
  $version             = params_lookup( 'version' ),
  $absent              = params_lookup( 'absent' ),
  $audit_only          = params_lookup( 'audit_only' , 'global' ),
  $noops               = params_lookup( 'noops' ),
  $package             = params_lookup( 'package' ),
  $config_dir          = params_lookup( 'config_dir' ),
  $config_file         = params_lookup( 'config_file' )
  ) inherits locales::params {

  $config_file_mode=$locales::params::config_file_mode
  $config_file_owner=$locales::params::config_file_owner
  $config_file_group=$locales::params::config_file_group

  $bool_absent=any2bool($absent)
  $bool_audit_only=any2bool($audit_only)
  $bool_noops=any2bool($noops)

  ### Definition of some variables used in the module
  $manage_package = $locales::bool_absent ? {
    true  => 'absent',
    false => $locales::version,
  }

  $manage_file = $locales::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  $manage_audit = $locales::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $locales::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $manage_file_source = $locales::source ? {
    ''        => undef,
    default   => $locales::source,
  }

  $array_locales = is_array($locales) ? {
    false     => $locales ? {
      ''      => [],
      default => [$locales],
    },
    default   => $locales,
  }

  $manage_file_content = $locales::template ? {
    ''        => undef,
    default   => template($locales::template),
  }

  ### Managed resources
  if $locales::package != '' {
    package { $locales::package:
      ensure  => $locales::manage_package,
      noop    => $locales::bool_noops,
    }
    $package_require = "Package[${locales::package}]"
  } else {
    $package_require = undef
  }

  file { 'locales.conf':
    ensure  => $locales::manage_file,
    path    => $locales::config_file,
    mode    => $locales::config_file_mode,
    owner   => $locales::config_file_owner,
    group   => $locales::config_file_group,
    require => $locales::package_require,
    source  => $locales::manage_file_source,
    content => $locales::manage_file_content,
    replace => $locales::manage_file_replace,
    audit   => $locales::manage_audit,
    noop    => $locales::bool_noops,
  }

  if $locales::generate_command != '' {
    exec { 'generate_locales':
      command     => $locales::generate_command,
      refreshonly => true,
      require     => $locales::package_require,
      subscribe   => File['locales.conf'],
    }
  }

  ### Include custom class if $my_class is set
  if $locales::my_class {
    include $locales::my_class
  }

}
