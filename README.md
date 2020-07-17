# Speedo

Measure revolutions by second based on a GPIO pin.

## Installation

Add `speedo` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:speedo, "~> 0.1.0"}
  ]
end
```

Then in your supervision tree add a monitor like:

```elixir
pin_number = 17 # the BCM pin number
children = [
  ...your other children,
  {Speedo.Monitor, pin_number}
]
```

And finally in whatever part of your application is interested you can call:

```elixir
Speedo.Monitor.subscribe(pin_number)
```

And that process will begin receiving messages each time the speed is measured.
These messages look like:

```elixir
{:speedo_rps, pin_number, rps}
# rps is a floating point number representing how many revolutions per second we have most recently measured
```

