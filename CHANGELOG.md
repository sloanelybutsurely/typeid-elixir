# Changelog

## 0.5.1

- raises if `prefix` is not given when `primary_key: true`

## 0.5.0

- `Ecto.ParameterizedType` implementation traverses associations so prefixes only need to be defined on schema primary keys
- `Ecto.ParameterizedType` implementation `type` option can be set globally with a `default_type` Application configuration

## 0.4.0

- Implements `Jason.Encoder` protocol
- **BREAKING:** The `_` seperator is no longer encoded as a binary when returned by `TypeID.to_iodata/1` or protocols that use that function. This is unlikely to matter unless you are pattern matching on the shape of the returned iodata.

## 0.3.1

- Implements `String.Chars` protocol
- Implements `Phoenix.HTML.Safe` protocol
- Implements `Phoenix.Param` protocol

## 0.3.0

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
