# TypeID Elixir

[![CI](https://github.com/sloanelybutsurely/typeid-elixir/actions/workflows/ci.yaml/badge.svg)](https://github.com/sloanelybutsurely/typeid-elixir/actions/workflows/ci.yaml)

Read the full documentation on [hexdocs](https://hexdocs.pm/typeid_elixir/TypeID.html)

### A type-safe, K-sortable, globally unique identifier inspired by Stripe IDs

[TypeIDs](https://github.com/jetpack-io/typeid) are a modern, type-safe, globally unique identifier based on the upcoming UUIDv7 standard. They provide a ton of nice properties that make them a great choice as the primary identifiers for your data in a database, APIs, and distributed systems. Read more about TypeIDs in their spec.

## Installation

The package can be installed from [hex](https://hex.pm/packages/typeid_elixir) by adding `typeid_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:typeid_elixir, "~> 0.2.2"}
  ]
end
```

## Spec

The original TypeID spec is defined [here](https://github.com/jetpack-io/typeid).

## Usage with Ecto

`TypeID` implements the `Ecto.ParameterizedType` behaviour so you can use
TypeIDs as fields in your Ecto schemas.

```elixir
defmodule MyApp.Accounts.User do
  use Ecto.Schema

  @primary_key {:id, TypeID, autogenerate: true, prefix: "acct", type: :binary_id}

  # ...
end
```
