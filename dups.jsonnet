#!/usr/bin/env jsonnet
# to be invokes as `$0 -V repo=$(git config remote.origin.url) -S -m ${dir:-tmp}`

local conf = import 'dups.libsonnet';
local nodes = import 'ext/data-nodes/oxa-duplicity.jsonnet';

local wheezy = [ 'root', 'boot', 'usr', 'var', 'home', 'space' ];
local vols = std.filter(function(x) x != 'usr', wheezy);
local base = 90;

local seqs = std.foldl(function(a, b) a + b, std.mapWithIndex(function(i, e) { [e]: base + i }, vols), {});

local dups = { 
  [vol]: conf + { seq:: seqs[vol], vol: vol } for vol in vols
};

local mode = '# -*- Mode: conf; -*-\n';
local info = '# Generated from ' + std.extVar('repo') + '\n\n';

{
  local args = {
    node: node,
    local dups = nodes.dups,
    groups: dups.groups[node],
    backup: dups.backup[node],
    backup_fqdn: nodes.fqdn[self.backup],
    symmetric: dups.symmetric[node],
    etc: dups.etc[node],
  },
  [ node + '/' + dups[vol].seq + '.' + vol + '.dup' ]:
    mode + info + std.manifestIni((dups[vol] + args).default) for vol in vols for node in nodes.dups.nodes
}

# Local Variables:
# indent-tabs-mode: nil
# End:
