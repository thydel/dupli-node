local parts = {
  prefix: {
    default: "'node/'"
  },
  user: {
    env: "lookup('env','USER')",
    id: "lookup('pipe', 'id -un')",
    default: self.env,
  },
  node: {
    default: "lookup('pipe', 'hostname -s')",
    simple: "'localhost'",
  },
};

local path(prefix = 'default', user = 'default', node = 'default') =
parts.prefix[prefix] + ' ~ ' + parts.user[user] + " ~ '@' ~ " + parts.node[node];

local paths = {
  default: path(),
  simple:  path(node = 'simple'),
  alt:     path(user = 'id', node = 'simple'),
};

local pass(path) = "{{ lookup('passwordstore', " + path + ") }}";

local passwords = {
  default: pass(paths.default),
  simple: pass(paths.simple),
};

local inventory = {
  all: {
    hosts: {
      'local': {
        ansible_connection: 'local',
        ansible_become_pass: passwords.default,
      },
    },
  },
};

{ 'local.yml': "---\n\n" + std.manifestYamlDoc(inventory) }

# Local Variables:
# indent-tabs-mode: nil
# End:
