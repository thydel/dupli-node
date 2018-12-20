//

local ssh = {
  base: {
    pipelining: true,
  },
};

local defaults = {

  local dir(path) = local tmp = std.split(path, '/'); std.join('/', tmp[:std.length(tmp) - 1]),

  base: {
    inventory: 'inventory',
    hosts: 'default',
    retry_files_enabled: false,
    dirs:: self.inventory,
  },
  log: {
    log_path: 'log/ansible.log',
    dirs:: dir(self.log_path),
  },
  caching: {
    fact_caching: 'jsonfile',
    fact_caching_connection: '.cache/ansible',
    fact_caching_timeout: 86400,
    dirs:: self.fact_caching_connection,
  },
  retry: {
    retry_files_enabled: true,
    retry_files_save_path: '.retry',
    dirs:: self.retry_files_save_path,
  },
  roles: {
    roles_path: 'roles',
    dirs:: self.roles_path,
  },
  misc: {
    gathering: 'smart',
    merge_multiple_cli_tags: true,
    stdout_callback: 'debug',
    'jinja2_extensions': 'jinja2.ext.do',
    ansible_managed: 'Ansible managed',
  },
};

local collect(v, k, l = []) =
  local clean(l) = std.flattenArrays(std.prune(l));
  if std.isObject(v) then
    local f = std.setDiff(std.set(std.objectFieldsAll(v)),[k]),
          r = clean([ collect(v[i], k, l) for i in f ]);
    if std.objectHasAll(v, k) then
       l + if std.isArray(v[k]) then v[k] else [ v[k] ] + r
    else
       l + r
  else if std.isArray(v) then
    l + clean([ collect(i, k, l) for i in v ]);

local confs = {

  local merge(a) = std.foldl(function(b, k) b + a[k], std.objectFields(a), {}),

  mini: {
    sections: {
      defaults: defaults.base,
      ssh: ssh.base,
    },
  },
  simple: self.mini + { sections +: { defaults +: defaults.log }},
  full: self.mini + { sections +: { defaults: merge(defaults) }},
};

{
  [conf + '.cfg']: std.manifestIni(confs[conf]) for conf in std.objectFields(confs) } + {

  local c = collect(defaults, 'dirs'),
  local i = std.map(base, c),
  local base(path) = std.split(path, '/')[0],
  'dirs.yml': std.manifestYamlDoc({ dirs: c, gitignore: i }),
}
  
# Local Variables:
# indent-tabs-mode: nil
# End:
