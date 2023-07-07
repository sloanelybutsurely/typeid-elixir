# Changelog

## main

- **BREAKING:** `type/1` has been renamed to `prefix/1`
- `Ecto.ParameterizedType` implementation
- `new/2` now accepts an optional keyword list to specify the UUID `time:` in unix milliseconds

```elixir
iex> TypeID.new("test", time: 0)
#TypeID<"test_0000000000fq893mf5039xea5j">
```

## 0.2.2

- Lower required Elixir version

## 0.2.1

- Include CHANGELOG in docs
- Remove dependency on `Uniq`

## 0.2.0

Validate against 0.2.0 spec

## 0.1.0

Validate against 0.1.0 spec

## 0.0.1

Initial release
