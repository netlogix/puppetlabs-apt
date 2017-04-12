require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'puppet_x', 'apt_key', 'resource_api.rb'))

register_type({
    name: 'apt_key2',
    docs: <<-EOS,
      This type provides Puppet with the capabilities to manage GPG keys needed
      by apt to perform package validation. Apt has it's own GPG keyring that can
      be manipulated through the `apt-key` command.

      apt_key { '6F6B15509CF8E59E6E469F327F438280EF8D349F':
        source => 'http://apt.puppetlabs.com/pubkey.gpg'
      }

      **Autorequires**:
      If Puppet is given the location of a key file which looks like an absolute
      path this type will autorequire that file.
    EOS
    attributes:   {
        ensure:      {
            type: 'Enum[present, absent]',
            docs: 'Whether this apt key should be present or absent on the target system.'
        },
        id:          {
            type:    'Variant[Pattern[/\A(0x)?[0-9a-fA-F]{8}\Z/], Pattern[/\A(0x)?[0-9a-fA-F]{16}\Z/], Pattern[/\A(0x)?[0-9a-fA-F]{40}\Z/]]',
            docs:    'The ID of the key you want to manage.',
            namevar: true,
        },
        content:     {
            type: 'Optional[String]',
            docs: 'The content of, or string representing, a GPG key.',
        },
        source:      {
            type: 'Variant[Stdlib::Absolutepath, Pattern[/\A(https?|ftp):\/\//]]',
            docs: 'Location of a GPG key file, /path/to/file, ftp://, http:// or https://',
        },
        server:      {
            type:    'Pattern[/\A((hkp|http|https):\/\/)?([a-z\d])([a-z\d-]{0,61}\.)+[a-z\d]+(:\d{2,5})?$/]',
            docs:    'The key server to fetch the key from based on the ID. It can either be a domain name or url.',
            default: :'keyserver.ubuntu.com'
        },
        options:     {
            type: 'Optional[String]',
            docs: 'Additional options to pass to apt-key\'s --keyserver-options.',
        },
        fingerprint: {
            type:      'Pattern[/[a-f]{40}/]',
            docs:      'The 40-digit hexadecimal fingerprint of the specified GPG key.',
            read_only: true,
        },
        long:        {
            type:      'Pattern[/[a-f]{16}/]',
            docs:      'The 16-digit hexadecimal id of the specified GPG key.',
            read_only: true,
        },
        short:       {
            type:      'Pattern[/[a-f]{8}/]',
            docs:      'The 8-digit hexadecimal id of the specified GPG key.',
            read_only: true,
        },
        expired:     {
            type:      'Boolean',
            docs:      'Indicates if the key has expired.',
            read_only: true,
        },
        expiry:      {
            # TODO: should be DateTime
            type:      'String',
            docs:      'The date the key will expire, or nil if it has no expiry date, in ISO format.',
            read_only: true,
        },
        size:        {
            type:      'Integer',
            docs:      'The key size, usually a multiple of 1024.',
            read_only: true,
        },
        type:        {
            type:      'String',
            docs:      'The key type, one of: rsa, dsa, ecc, ecdsa.',
            read_only: true,
        },
        created:     {
            type:      'String',
            docs:      'Date the key was created, in ISO format.',
            read_only: true,
        },
    },
    autorequires: {
        file:    '$source', # will evaluate to the value of the `source` attribute
        package: 'apt',
    },
})
