# Development::Pod

A runtime pod providing a variety of facilities supporting interactive and test-driven development.

## Installation

After checking out the repo, run `bin/setup` to install all the required dependencies. Then, run `bundle exec rake build` to build development-pod-version.gem into the pkg directory. Finally run `bundle exec rake install` to install development-pod-version.gem into the system gems.

## Usage

Create a folder /my/own/path/ where you plan to start a new development project. Once there create a new YAML file called _pod.yml_ with the following content:

```yaml
---
podname: mypodname
runtime: myruntime
```

where _mypodname_ is the name of the directory under which the development environment will be created and _myruntime_ is the name of the runtime supported by the created development environment. Currently only the following runtimes are supported:

- _boot_ corresponding to a spring boot rest application
- _java_ corresponding to a simple java core application
- _ruby_ corresponding to a gem ready for deployment
- _vite_ corresponding to a react application using vite

Once you have created _pod.yml_ run `pod ping` to test your local installation, with the expected result:

```shell
❯ pod ping
Object:upload! uploading: /my/own/path/pod.yml
Development::CLI:execute_command executing ping...
pong
```

Next run `pod` to get a description of the available _pod_ commands:

```shell
❯ pod
Object:upload! uploading: /my/own/path/pod.yml
Commands:
  pod create          # Creates a runtime pod
  pod deploy          # Deploys a runtime pod
  pod help [COMMAND]  # Describes cli command
  pod ping            # Provides a test reply
  pod remove          # Removes a runtime pod
  pod update          # Updates a runtime pod
  pod version         # Prints version number
```

## Development

After checking out the repo, run `bin/setup` to install all the required dependencies. Then, run `bundle exec rake` to run both tests and linting. You can also run `bin/console` for an interactive prompt that will allow you to experiment further.

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/gzamfir-ca/development-pod>.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
