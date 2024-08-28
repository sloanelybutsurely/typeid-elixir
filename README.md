# TypeID Elixir

[![CI](https://github.com/sloanelybutsurely/typeid-elixir/actions/workflows/ci.yaml/badge.svg)](https://github.com/sloanelybutsurely/typeid-elixir/actions/workflows/ci.yaml) [![Hex.pm](https://img.shields.io/hexpm/v/typeid_elixir.svg)](https://hex.pm/packages/typeid_elixir) [![Documentation](https://img.shields.io/badge/documentation-gray)](https://hexdocs.pm/typeid_elixir)

### A type-safe, K-sortable, globally unique identifier inspired by Stripe IDs

[TypeIDs](https://github.com/jetpack-io/typeid) are a modern, type-safe, globally unique identifier based on the upcoming UUIDv7 standard. They provide a ton of nice properties that make them a great choice as the primary identifiers for your data in a database, APIs, and distributed systems. Read more about TypeIDs in their spec.

## Installation

The package can be installed from [hex](https://hex.pm/packages/typeid_elixir) by adding `typeid_elixir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:typeid_elixir, "~> 0.5.0"}
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

  @primary_key {:id, TypeID, autogenerate: true, prefix: "acct", type: :uuid}
  @foreign_key_type TypeID

  # ...
end
```

### Underlying types

`TypeID`s can be stored as either `:string` or `:uuid`. `:string` will store
the entire TypeID including the prefix. `:uuid` stores only the UUID portion
and requires a `:uuid` or `:uuid` column.

#### Default type

The type used can be set globally in the application config.

```elixir
config :typeid_elixir,
  default_type: :uuid
```
