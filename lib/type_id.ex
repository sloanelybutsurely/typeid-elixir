defmodule TypeID do
  @moduledoc """
  Documentation for `TypeID`.
  """

  alias TypeID.Base32

  @enforce_keys [:prefix, :suffix]
  defstruct @enforce_keys

  @opaque t() :: %__MODULE__{
            prefix: String.t(),
            suffix: String.t()
          }

  @spec new(prefix :: String.t()) :: t()
  def new(prefix) do
    suffix =
      Uniq.UUID.uuid7(:raw)
      |> Base32.encode()

    %__MODULE__{prefix: prefix, suffix: suffix}
  end

  @spec type(tid :: t()) :: String.t()
  def type(%__MODULE__{prefix: prefix}) do
    prefix
  end

  @spec suffix(tid :: t()) :: String.t()
  def suffix(%__MODULE__{suffix: suffix}) do
    suffix
  end

  @spec to_string(tid :: t()) :: String.t()
  def to_string(%__MODULE__{prefix: prefix, suffix: suffix}) do
    prefix <> "_" <> suffix
  end

  @spec uuid_bytes(tid :: t()) :: binary()
  def uuid_bytes(%__MODULE__{suffix: suffix}) do
    Base32.decode!(suffix)
  end

  @spec uuid(tid :: t()) :: String.t()
  def uuid(%__MODULE__{suffix: suffix}) do
    suffix
    |> Base32.decode!()
    |> Uniq.UUID.to_string(:default)
  end

  @spec from_string!(String.t()) :: t() | no_return()
  def from_string!(str) do
    [prefix, suffix] = String.split(str, "_")
    from!(prefix, suffix)
  end

  @spec from!(prefix :: String.t(), suffix :: String.t()) :: t() | no_return()
  def from!(prefix, suffix) do
    validate_prefix!(prefix)
    validate_suffix!(suffix)

    %__MODULE__{prefix: prefix, suffix: suffix}
  end

  @spec from(prefix :: String.t(), suffix :: String.t()) :: {:ok, t()} | :error
  def from(prefix, suffix) do
    {:ok, from!(prefix, suffix)}
  rescue
    ArgumentError -> :error
  end

  @spec from_string!(String.t()) :: {:ok, t()} | :error
  def from_string(str) do
    {:ok, from_string!(str)}
  rescue
    ArgumentError -> :error
  end

  @spec from_uuid!(prefix :: String.t(), uuid :: String.t()) :: t() | no_return()
  def from_uuid!(prefix, uuid) do
    {:ok, %Uniq.UUID{bytes: uuid_bytes, version: 7}} = Uniq.UUID.parse(uuid)
    from_uuid_bytes!(prefix, uuid_bytes)
  end

  @spec from_uuid_bytes!(prefix :: String.t(), uuid_bytes :: binary()) :: t() | no_return()
  def from_uuid_bytes!(prefix, <<uuid_bytes::binary-size(16)>>) do
    suffix = Base32.encode(uuid_bytes)
    from!(prefix, suffix)
  end

  @spec from_uuid(prefix :: String.t(), uuid :: String.t()) :: {:ok, t()} | :error
  def from_uuid(prefix, uuid) do
    {:ok, from_uuid!(prefix, uuid)}
  rescue
    ArgumentError -> :error
  end

  @spec from_uuid_bytes(prefix :: String.t(), uuid_bytes :: binary()) :: {:ok, t()} | :error
  def from_uuid_bytes(prefix, uuid_bytes) do
    {:ok, from_uuid_bytes!(prefix, uuid_bytes)}
  rescue
    ArgumentError -> :error
  end

  defp validate_prefix!(prefix) do
    unless prefix =~ ~r/^[a-z]{0,63}$/ do
      raise ArgumentError, "invalid prefix: #{prefix}. prefix should match [a-z]{0,63}"
    end

    :ok
  end

  defp validate_suffix!(suffix) do
    Base32.decode!(suffix)

    :ok
  end
end

defimpl Inspect, for: TypeID do
  import Inspect.Algebra

  def inspect(tid, _opts) do
    concat(["TypeID.from_string!(\"", tid.prefix, "_", tid.suffix, "\")"])
  end
end
