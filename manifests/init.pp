# Class: debianmirror
#
# This module manages debian mirrors.
#
# Parameters:
# template 
# mirror
# distribution
# components
#
# Actions:
#
# Requires: apt-mirror debian package
#
# Sample Usage:
#
#   include debianmirror
#   debianmirror::instance{
#     test:
#   }
#
# [Remember: No empty lines between comments and class definition]
class debianmirror (
    $template = 'debianmirror/mirror.list.erb',
    $mirror = 'ftp.us.debian.org',
    $distribution = 'unstable',
    $components = 'main contrib non-free') {

  package {
    'apt-mirror':
      ensure => present;
  }

  file {
    '/etc/apt/mirror.list':
        ensure => present,
        mode    => 644,
        owner   => root,
        group   => root,
        content => template($template);
    '/etc/cron.d/apt-mirror':
        ensure  => present,
        mode    => 644,
        owner   => root,
        group   => root,
        content => template('debianmirror/cron.erb');
  }
}
