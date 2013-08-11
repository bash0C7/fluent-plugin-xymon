# fluent-plugin-xymon

Fluentd output plugin to post message to xymon

## Installation

Install gem

````
fluent-gem install fluent-plugin-xymon
````

## config

````ruby
    config_param :xymon_server, :string
    config_param :xymon_port, :string, :default => '1984'
    config_param :color, :string, :default => 'green'
    config_param :hostname, :string
    config_param :testname, :string
    config_param :name_key, :string
    config_param :custom_determine_color_code, :string, :default => nil
````

### example

````
<store>
  type xymon
  xymon_server                127.0.0.1
  xymon_port                  1984
  color                       green
  hostname                    web-server-01
  testname                    CPU
  name_key                    CPUUtilization
  custom_determine_color_code if value.to_i > 90; 'red'; else 'green'; end
</store>
````

## config_param :custom_determine_color_code

set ruby code of determinate color to custom_determine_color_code.

### Parameter

time, record, value

### Example

#### everytime 'green'

````
custom_determine_color_code return 'green'
````

#### if value > 90 then 'red' else 'green'

````
custom_determine_color_code if  value > 90; 'red'; else 'green'; end
````

### config_param :color

ignore :color if custom_determine_color_code is exist and valid.
use :color if custom_determine_color_code is noting or invalid

### If raise some exception

server didn't respond

- use config color value
- write warn log

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## releases

- 2013/08/09 0.0.0 1st release
- 2013/08/10 0.0.1 https://github.com/bash0C7/fluent-plugin-xymon/pull/1
