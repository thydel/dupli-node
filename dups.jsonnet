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
  [ node + '/' + dups[vol].seq + '.' + vol + '.dup' ]:
    mode + std.manifestIni((dups[vol] +
      { node: node, groups: nodes.dups.groups[node] }).default) for vol in vols for node in nodes.dups.nodes
}
