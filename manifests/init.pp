# Class: debianmirror
#
# This module manages debian mirrors.
#
# Parameters:
# template: to override default template
# mirror: host to mirror from (ftp.us.debian.org)
# distributions:['unstable']
# components: 'main contrib non-free'
# architectures: extra architectures to mirror
# sources: mirror sources (true)
# enabled: enable cron job (true)
# nthreads: 20
# Actions:
#
# Requires: apt-mirror debian package
#
# Sample Usage:
#
#   include debianmirror
#
# [Remember: No empty lines between comments and class definition]
class debianmirror (
    $template = 'debianmirror/mirror.list.erb',
    $mirror = 'ftp.us.debian.org',
    $distributions = ['unstable'],
    $components = 'main contrib non-free',
    $architectures = [],
    $sources = true,
    $nthreads = 20,
    $enabled = true) {

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
        ensure  => $enabled ? {
          true  => present,
          false => absent,
        },
        mode    => 644,
        owner   => root,
        group   => root,
        content => template('debianmirror/cron.erb');
  }
}
