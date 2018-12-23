#!/usr/bin/env jsonnet
# to be invokes ad `$0 -S -m tmp`

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

{
  local args = {
    node: node,
    local dups = nodes.dups,
    groups: dups.groups[node],
    backup: dups.backup[node],
    backup_fqdn: nodes.fqdn[self.backup]
  },
  [ node + '/' + dups[vol].seq + '.' + vol + '.dup' ]:
    mode + std.manifestIni((dups[vol] + args).default) for vol in vols for node in nodes.dups.nodes
}

# Local Variables:
# indent-tabs-mode: nil
# End:
