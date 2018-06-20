# == Class gitlab::omnibus_config
#
# This class is used to configure the gitlab omnibus package on a node
#
class gitlab::omnibus_config (
  $config_manage = $gitlab::config_manage,
  $config_file = $gitlab::config_file
){

  # get variables from the toplevel manifest for usage in the template
  $ci_redis = $gitlab::ci_redis
  $ci_unicorn = $gitlab::ci_unicorn
  $external_url = $gitlab::external_url
  $external_port = $gitlab::external_port
  $geo_postgresql = $gitlab::geo_postgresql
  $geo_primary_role = $gitlab::geo_primary_role
  $geo_secondary = $gitlab::geo_secondary
  $geo_secondary_role = $gitlab::geo_secondary_role
  $git = $gitlab::git
  $gitaly = $gitlab::gitaly
  $git_data_dirs = $gitlab::git_data_dirs
  $gitlab_git_http_server = $gitlab::gitlab_git_http_server
  $gitlab_ci = $gitlab::gitlab_ci
  $gitlab_pages = $gitlab::gitlab_pages
  $gitlab_rails = $gitlab::gitlab_rails
  $high_availability = $gitlab::high_availability
  $letsencrypt = $gitlab::letsencrypt
  $logging = $gitlab::logging
  $logrotate = $gitlab::logrotate
  $manage_storage_directories = $gitlab::manage_storage_directories
  $manage_accounts = $gitlab::manage_accounts
  $mattermost = $gitlab::mattermost
  $mattermost_external_url = $gitlab::mattermost_external_url
  $mattermost_nginx = $gitlab::mattermost_nginx
  $mattermost_nginx_eq_nginx = $gitlab::mattermost_nginx_eq_nginx
  $nginx = $gitlab::nginx
  $node_exporter = $gitlab::node_exporter
  $redis_exporter = $gitlab::redis_exporter
  $postgres_exporter = $gitlab::postgres_exporter
  $gitlab_monitor = $gitlab::gitlab_monitor
  $pages_external_url = $gitlab::pages_external_url
  $pages_nginx = $gitlab::pages_nginx
  $pages_nginx_eq_nginx = $gitlab::pages_nginx_eq_nginx
  $postgresql = $gitlab::postgresql
  $prometheus = $gitlab::prometheus
  $prometheus_monitoring_enable = $gitlab::prometheus_monitoring_enable
  $redis = $gitlab::redis
  $redis_master_role = $gitlab::redis_master_role
  $redis_slave_role = $gitlab::redis_slave_role
  $redis_sentinel_role = $gitlab::redis_sentinel_role
  $registry = $gitlab::registry
  $registry_nginx = $gitlab::registry_nginx
  $registry_nginx_eq_nginx = $gitlab::registry_nginx_eq_nginx
  $registry_external_url = $gitlab::registry_external_url
  $secrets = $gitlab::secrets
  $secrets_file = $gitlab::secrets_file
  $sentinel = $gitlab::sentinel
  $service_group = $gitlab::service_group
  $service_user = $gitlab::service_user
  $rake_exec = $gitlab::rake_exec
  $shell = $gitlab::shell
  $sidekiq = $gitlab::sidekiq
  $sidekiq_cluster = $gitlab::sidekiq_cluster
  $source_config_file = $gitlab::source_config_file
  $unicorn = $gitlab::unicorn
  $gitlab_workhorse = $gitlab::gitlab_workhorse
  $user = $gitlab::user
  $web_server = $gitlab::web_server
  $roles = $gitlab::roles

  # replicate $nginx to $mattermost_nginx if $mattermost_nginx_eq_nginx true
  if $mattermost_nginx_eq_nginx {
    $_real_mattermost_nginx = $nginx
  } else {
    $_real_mattermost_nginx = $mattermost_nginx
  }

  # replicate $nginx to $pages_nginx if $pages_nginx_eq_nginx true
  if $pages_nginx_eq_nginx {
    $_real_pages_nginx = $nginx
  } else {
    $_real_pages_nginx = $pages_nginx
  }

  # replicate $nginx to $registry_nginx if $registry_nginx_eq_nginx true
  if $registry_nginx_eq_nginx {
    $_real_registry_nginx = $nginx
  } else {
    $_real_registry_nginx = $registry_nginx
  }

  # attributes shared by all config files used by omnibus package
  $config_file_attributes = {
    ensure => 'present',
    owner  => $service_user,
    group  => $service_group,
    mode   => '0600',
  }

  if $config_manage {
    if $source_config_file {
      file { $config_file:
        *      => $config_file_attributes,
        source => $source_config_file,
      }
    } else {
      file { $config_file:
        *       => $config_file_attributes,
        content => template('gitlab/gitlab.rb.erb');
      }
    }
  }

  if ! empty($secrets) {
    file { $secrets_file:
      *       => $config_file_attributes,
      content => inline_template('<%= require \'json\'; JSON.pretty_generate(@secrets) + "\n" %>'),
    }
  }
}