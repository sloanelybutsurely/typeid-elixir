# TypeID Elixir

### A type-safe, K-sortable, globally unique identifier inspired by Stripe IDs

[TypeIDs](https://github.com/jetpack-io/typeid) are a modern, type-safe, globally unique identifier based on the upcoming UUIDv7 standard. They provide a ton of nice properties that make them a great choice as the primary identifiers for your data in a database, APIs, and distributed systems. Read more about TypeIDs in their spec.

## Installation

The package can be installed by adding `typeid` to your list of dependencies in
`mix.exs`:

```elixir
def deps do
  [
    {:typeid, "~> 0.1.0"}
  ]
end
```

## Spec

The original TypeID spec is defined [here](https://github.com/jetpack-io/typeid).
