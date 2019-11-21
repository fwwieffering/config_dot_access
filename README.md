# config_dot_access
Simple template for a yaml-based ruby config module

Config values can be accessed via dot or bracket notation. Raises `ConfigError` exception if an item is not found

e.g. config file `config.yaml`
```yaml
foo:
    bar:
        car: dar

mister: manager

things:
- name: thing1
- name: thing2
```

```ruby
require 'config.rb'

# load config
Config.load!('config.yaml')

Config.foo
# output: {'bar' => {'car' => 'dar'}}

Config.mister
# output: 'manager'

Config.things[0].name
# output: 'thing1'

Config.owkefokwfeok
# Raises ConfigError "unknown configuration option ..."
```
