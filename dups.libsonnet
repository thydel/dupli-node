local nicelevel = 19;
local testconnect = 'no';

local archive = ' --archive-dir ';
local name = ' --name ';
local volsize = ' --volsize ';
local onefs = ' --exclude-other-filesystems';

local sep = '+';

{
  when:: 'everyday at 00:20',
  backup:: error 'No default backup node',
  backup_fqdn: error 'No default backup_fqnd node',
  node:: error 'No default node',
  vol:: error 'No default vol',
  base:: '/space/duplicity',

  etcs:: {
    new: $.base + '/etc',
    old: '/etc/duplicity' },
  etcdir:: self.etcs[self.etc],
  etc:: 'new',

  tmpdir:: self.base + '/tmp',
  archive:: self.base + '/archive',
  volsize:: 500,
  name:: self.backup + sep + self.node + sep + self.vol,
  options:: archive + self.archive + name + self.name + volsize + self.volsize + if self.vol == 'root' then onefs else '',
  groups:: [],
  symmetric:: false,

  default:: {

    main: {
      when: $.when,
      nicelevel: nicelevel,
      testconnect: testconnect,
      tmpdir: $.tmpdir,
      options: $.options,
    },
    sections: {
      local password_file = $.etcdir + '/' + $.node,
      local encryptkey = "'" + '<duplicity@' + $.node + '>' + "'",
      gpg: {
        sign: 'no',
        password: 'dummy',      # required by backupninja but useless for duplicity
      } + if $.symmetric then {
        password_file: password_file,
        encryptkey_hidden: encryptkey
      } else {
        encryptkey: encryptkey,
        password_file: password_file
      },
      dest: {
        sshoptions: '-oIdentityFile=' + $.etcdir + '/' + $.node + '-duplicity',
        desthost:: $.backup_fqdn,
        destuser:: 'duplicity',
        destdir:: 'store/' + $.node + '/' + $.vol,
        desturl: $.proto + '://' + self.destuser + '@' + self.desthost + '/' + self.destdir,
      } + $.dests[$.vol],
      source: $.sources[$.vol],
    },
  },
  dests:: {
    default: {
      incremental: 'yes',
      increments: 7,
      keep: 60,
      keepincroffulls: 3,
    },
    root: self.default,
    boot: self.default,
    var:  self.default,
    home: self.default,
    space: self.default { keepincroffulls: 2 },
  },
  excludes: {
    space: ['/space/duplicity', '/space/2rm' ]
  },
  sources:: {
    root: {
      include: '/*', /**/
      exclude: if std.setMember('nospace', $.groupsOK) then $.excludes.space  else ['/space'],
    },
    boot: { include: '/boot' },
    var: {
      include: '/var',
      exclude: ['/var/cache/backupninja/duplicity', '/var/cache/apt/archives'],
    },
    home: { include: '/home' },
    space: {
      include: '/space',
      // exclude: ['/space/duplicity', '/space/2rm'] + if std.length($.groups) > 0 then std.flattenArrays(std.map(function(group) self.excludes[group], $.groups)) else [],
      exclude: $.excludes.space + if std.length($.groups) > 0 then std.flattenArrays(std.map(function(group) self.excludes[group], $.groups)) else [],
      // local excludesForGroup(group) = if std.objectHas(self.excludes, group) then self.excludes[group] else [],
      // exclude: $.excludes.space + if std.length($.groups) > 0 then std.flattenArrays(std.map(excludesForGroup, $.groups)) else [],
      excludes:: {
        automysqlbackup: [
          '/space/automysqlbackup/daily',
          '/space/automysqlbackup/weekly',
          '/space/automysqlbackup/monthly',
        ],
        sqldump: [ '/space/nfsdata/*/automysqlbackup/' + i for i in [ 'daily', 'weekly', 'monthly' ]],
      },
    },
  },
}

# Local Variables:
# indent-tabs-mode: nil
# End:
