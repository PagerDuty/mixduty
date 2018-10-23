# Mixduty

A simple elixir client for the PagerDuty v2 API.

[Full Documentation](https://hexdocs.pm/mixduty/api-reference.html)

## Installation

Install by adding `mixduty` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mixduty, "~> 0.1.0"}
  ]
end
```

```
$ mix deps.get
```

## Example Usage

Initialize a new client with a valid auth token:
```
$ iex -S mix
iex(1)> client = Mixduty.Client.new("MY_TOKEN")
%Mixduty.Client{
  headers: [
    {"Accept", "application/vnd.pagerduty+json;version=2"},
    {"Authorization", "Token token=y_NbAkKc66ryYTWUXYEu"},
    {"Content-type", "application/json"}
  ]
}
```
Pass client to function calls described in documentation:
```
iex(2)> Mixduty.Users.list(client)
```

## License
[MIT](https://opensource.org/licenses/MIT)

## Contributing

1. Fork it ( https://github.com/PagerDuty/mixduty/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
