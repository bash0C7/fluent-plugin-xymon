# fluent-plugin-xymon

Fluentd output plugin to post message to xymon

## Installation

Install gem

    fluent-gem install fluent-plugin-xymon

## config

````ruby
    config_param :xymon_server, :string
    config_param :xymon_port, :string, :default => '1984'
    config_param :color, :string, :default => 'green'
    config_param :host, :string
    config_param :column, :string
    config_param :name_key, :string
````

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
