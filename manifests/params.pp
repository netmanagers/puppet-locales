# Class: locales::params
#
# This class defines default parameters used by the main module class locales
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to locales class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class locales::params {

  ### Application related parameters

  $package = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'locales',
    default                   => '',
  }

  $config_dir = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc',
    default                   => '/etc/sysconfig',
  }

  $config_file = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => '/etc/locales.gen',
    default                   => '/etc/sysconfig/i18n',
  }

  $template = $::operatingsystem ? {
    /(?i:Debian|Ubuntu|Mint)/ => 'locales/locale.gen.erb',
    default                   => 'locales/i18n.erb',
  }

  $config_file_mode = $::operatingsystem ? {
    default => '0644',
  }

  $config_file_owner = $::operatingsystem ? {
    default => 'root',
  }

  $config_file_group = $::operatingsystem ? {
    default => 'root',
  }

  $locales= ''

  # General Settings
  $my_class = ''
  $source = ''
  $options = ''
  $version = 'present'
  $absent = false
  $audit_only = false
  $noops = false
}
