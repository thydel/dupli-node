local nicelevel = 19;
local testconnect = 'no';

local archive = ' --archive-dir ';
local name = ' --name ';
local volsize = ' --volsize ';
local onefs = ' --exclude-other-filesystems';

local sep = '+';

{
  when:: 'everyday at 00:20',
  backup:: 'backup2',
  node:: 'localhost',
  vol:: error 'No default vol',
  base:: '/space/duplicity',
  tmpdir:: self.base + '/tmp',
  archive:: self.base + '/archive',
  volsize:: 500,
  name:: self.backup + sep + self.node + sep + self.vol,
  options:: archive + self.archive + name + self.name + volsize + self.volsize + if self.vol == 'root' then onefs else '',
  groups:: [],

  default:: {

    main: {
      when: $.when,
      nicelevel: nicelevel,
      testconnect: testconnect,
      tmpdir: $.tmpdir,
      options: $.options,
    },
    sections: {
      gpg: {
        encryptkey: 't.delamare@epiconcept.fr',
      },
      dest: {
        sshoptions: '-oIdentityFile=/etc/duplicity/' + $.node + '-duplicity',
        desthost: 'backup2.admin2.oxa.tld',
        destuser: 'duplicity',
        destdir: 'store/' + $.node + '/' + $.vol,
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
  sources:: {
    root: {
      include: '/*', /**/
      exclude: ['/space'],
    },
    boot: { include: '/boot' },
    var: {
      include: '/var',
      exclude: ['/var/cache/backupninja/duplicity', '/var/cache/apt/archives'],
    },
    home: { include: '/home' },
    space: {
      include: '/space',
      exclude: ['/space/duplicity'] + if std.length($.groups) > 0 then std.flattenArrays(std.map(function(group) self.excludes[group], $.groups)) else [],
      excludes:: {
        automysqlbackup: [
          '/space/automysqlbackup/daily',
          '/space/automysqlbackup/weekly',
          '/space/automysqlbackup/monthly',
        ],
      },
    },
  },
}
