#!/usr/bin/env jsonnet
# to be invokes as `$0 -V repo=$(git config remote.origin.url) -S -m ${dir:-tmp}`

local debug(obj) = (std.trace(std.toString(obj), obj));

local conf = import 'dups.libsonnet';
local nodes = import 'infra-data-nodes/oxa-duplicity.js';

local vols = {
  wheezy: [ 'root', 'boot', 'usr', 'var', 'home', 'space' ],
  std: std.filter(function(x) x != 'usr', self.wheezy),
  nospace: std.filter(function(x) x != 'space', self.std),
  choose(node): if std.setMember('nospace', std.set(nodes.groups[node])) then self.nospace else self.std,
};
local base = 90;

local seqs = std.foldl(function(a, b) a + b, std.mapWithIndex(function(i, e) { [e]: base + i }, vols.std), {});

local dups = { 
  [vol]: conf + { seq:: seqs[vol], vol: vol } for vol in vols.std
};

local mode = '# -*- Mode: conf; -*-\n';
local info = '# Generated from ' + std.extVar('repo') + '\n\n';

{
  local args = {
    node: node,
    local dups = nodes.dups,
    groups: dups.groups[node],
    groupsOK: nodes.groups[node],
    backup: dups.backup[node],
    backup_fqdn: nodes.fqdn[self.backup],
    proto: dups.proto[node],
    symmetric: dups.symmetric[node],
    etc: dups.etc[node],
    when: if std.objectHas(nodes.dups.when, node) then nodes.dups.when[node] else conf.when,
  },
  [ node + '/' + dups[vol].seq + '.' + vol + '.dup' ]:
    mode + info + std.manifestIni((dups[vol] + args).default) for node in nodes.dups.nodes for vol in vols.choose(node)
}

# Local Variables:
# indent-tabs-mode: nil
# End:
