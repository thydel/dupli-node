//

local ssh = {
  base: {
    pipelining: true,
  },
};

local defaults = {
  base: {
    inventory: 'inventory',
    hosts: 'default',
  },
  log: {
    log_path: 'log/ansible.log',
  },
  caching: {
    fact_caching: 'jsonfile',
    fact_caching_connection: '.cache/ansible',
    fact_caching_timeout: 86400,
  },
  retry: {
    retry_files_enabled: true,
    retry_files_save_path: '.retry',
  },
  misc: {
    gathering: 'smart',
    merge_multiple_cli_tags: true,
    stdout_callback: 'debug',
    'jinja2_extensions': 'jinja2.ext.do',
    ansible_managed: 'Ansible managed',
  },
};

local merge(a) = std.foldl(function(b, k) b + a[k], std.objectFields(a), {});

local confs = {
  mini: {
    sections: {
      defaults: defaults.base,
      ssh: ssh.base,
    },
  },
  simple: self.mini + { sections +: { defaults +: defaults.log }},
  full: self.mini + { sections +: { defaults: merge(defaults) }},
};

{ [conf + '.cfg']: std.manifestIni(confs[conf]) for conf in std.objectFields(confs) }
  
# Local Variables:
# indent-tabs-mode: nil
# End:
