# rake_deploy

## Description

This is a very small library for configuring rake tasks that copy local files to a remote host via rsync. The use case I have in mind is deploying static sites. It is less than 100 lines and its only dependency is Rake.

## Usage

Install it via rubygems or bundler.

You can configure deployment tasks by passing a YAML file to `load_file` or by passing a hash to `load`. Deployment tasks should have a name (like "staging" or "production"). The name should be the hash key to the config for that task. Config must include:

  - `source`: the local directory
  - `user`: the user on the remote
  - `domain`: the domain or IP of the remote
  - `target_dir`: the target directory on the remote

You can optionally pass any rsync options you want as an array in `rsync_options`. These must be formatted for command-line use ("--verbose", not "verbose").

In your Rakefile:

```ruby
require 'rake_deploy'

# Pass a YAML config file; an example if in test/fixtures
RakeDeploy.load_file('foo.yml')

# Pass a hash of config hashes
RakeDeploy.load({
  staging: {
    source: 'build',
    user: 'mydeployuser',
    rsync_options: %w(-og --chown=www-data:www-data --rsync-path="sudo rsync"),
    domain: 'www.sample.com',
    target_dir: '/var/www/mysite'
  }
})
```

You can run `rake --tasks` in your project directory to confirm the tasks have been loaded.

### Q & A

Q: Can I configure it to do X?

A: Use [rsync options](https://linux.die.net/man/1/rsync).

---

Q: Is this different from or better than just including an rsync command as a Rake task directly in my Rakefile?

A: Probably not. I like to keep this information as config instead of raw shell commands, so that, I guess.
