defmodule TypeID do
  @moduledoc File.cwd!() |> Path.join("README.md") |> File.read!()

  alias TypeID.Base32
  alias TypeID.UUID

  @enforce_keys [:prefix, :suffix]
  defstruct @enforce_keys

  @typedoc """
  An internal struct representing a `TypeID`.
  """
  @opaque t() :: %__MODULE__{
            prefix: String.t(),
            suffix: String.t()
          }

  @doc """
  Generates a new `t:t/0` with the given prefix.

  ### Example

      iex> TypeID.new("acct")
      #TypeID<"acct_01h45y0sxkfmntta78gqs1vsw6">

  """
  @spec new(prefix :: String.t()) :: t()
  def new(prefix) do
    suffix =
      UUID.uuid7()
      |> Base32.encode()

    %__MODULE__{prefix: prefix, suffix: suffix}
  end

  @doc """
  Returns the prefix of the given `t:t/0`.

  ### Example

      iex> tid = TypeID.new("doc")
      iex> TypeID.prefix(tid)
      "doc"

  """
  @spec prefix(tid :: t()) :: String.t()
  def prefix(%__MODULE__{prefix: prefix}) do
    prefix
  end

  @doc """
  Returns the base 32 encoded suffix of the given `t:t/0`

  ### Example

      iex> tid = TypeID.from_string!("invite_01h45y3ps9e18adjv9zvx743s2")
      iex> TypeID.suffix(tid)
      "01h45y3ps9e18adjv9zvx743s2"

  """
  @spec suffix(tid :: t()) :: String.t()
  def suffix(%__MODULE__{suffix: suffix}) do
    suffix
  end

  @doc """
  Returns a string representation of the given `t:t/0`

  ### Example

      iex> tid = TypeID.from_string!("user_01h45y6thxeyg95gnpgqqefgpa")
      iex> TypeID.to_string(tid)
      "user_01h45y6thxeyg95gnpgqqefgpa"

  """
  @spec to_string(tid :: t()) :: String.t()
  def to_string(%__MODULE__{prefix: "", suffix: suffix}) do
    suffix
  end

  def to_string(%__MODULE__{prefix: prefix, suffix: suffix}) do
    prefix <> "_" <> suffix
  end

  @doc """
  Returns the raw binary representation of the `t:t/0`'s UUID.

  ### Example

      iex> tid = TypeID.from_string!("order_01h45y849qfqvbeayxmwkxg5x9")
      iex> TypeID.uuid_bytes(tid)
      <<1, 137, 11, 228, 17, 55, 125, 246, 183, 43, 221, 167, 39, 216, 23, 169>>

  """
  @spec uuid_bytes(tid :: t()) :: binary()
  def uuid_bytes(%__MODULE__{suffix: suffix}) do
    Base32.decode!(suffix)
  end

  @doc """
  Returns `t:t/0`'s UUID as a string.

  ### Example

      iex> tid = TypeID.from_string!("item_01h45ybmy7fj7b4r9vvp74ms6k")
      iex> TypeID.uuid(tid)
      "01890be5-d3c7-7c8e-b261-3bdd8e4a64d3"

  """
  @spec uuid(tid :: t()) :: String.t()
  def uuid(%__MODULE__{} = tid) do
    tid
    |> uuid_bytes()
    |> UUID.binary_to_string()
  end

  @doc """
  Like `from/2` but raises an error if the `prefix` or `suffix` are invalid.
  """
  @spec from!(prefix :: String.t(), suffix :: String.t()) :: t() | no_return()
  def from!(prefix, suffix) do
    validate_prefix!(prefix)
    validate_suffix!(suffix)

    %__MODULE__{prefix: prefix, suffix: suffix}
  end

  @doc """
  Parses a `t:t/0` from a prefix and suffix. 

  ### Example

      iex> {:ok, tid} = TypeID.from("invoice", "01h45ydzqkemsb9x8gq2q7vpvb")
      iex> tid
      #TypeID<"invoice_01h45ydzqkemsb9x8gq2q7vpvb">

  """
  @spec from(prefix :: String.t(), suffix :: String.t()) :: {:ok, t()} | :error
  def from(prefix, suffix) do
    {:ok, from!(prefix, suffix)}
  rescue
    ArgumentError -> :error
  end

  @doc """
  Like `from_string/1` but raises an error if the string is invalid.
  """
  @spec from_string!(String.t()) :: t() | no_return()
  def from_string!(str) do
    case String.split(str, "_") do
      [prefix, suffix] when prefix != "" ->
        from!(prefix, suffix)

      [suffix] ->
        from!("", suffix)

      _ ->
        raise ArgumentError, "invalid TypeID"
    end
  end

  @doc """
  Parses a `t:t/0` from a string.

  ### Example

      iex> {:ok, tid} = TypeID.from_string("game_01h45yhtgqfhxbcrsfbhxdsdvy")
      iex> tid
      #TypeID<"game_01h45yhtgqfhxbcrsfbhxdsdvy">

  """
  @spec from_string(String.t()) :: {:ok, t()} | :error
  def from_string(str) do
    {:ok, from_string!(str)}
  rescue
    ArgumentError -> :error
  end

  @doc """
  Like `from_uuid/2` but raises an error if the `prefix` or `uuid` are invalid.
  """
  @spec from_uuid!(prefix :: String.t(), uuid :: String.t()) :: t() | no_return()
  def from_uuid!(prefix, uuid) do
    uuid_bytes = UUID.string_to_binary(uuid)
    from_uuid_bytes!(prefix, uuid_bytes)
  end

  @doc """
  Parses a `t:t/0` from a prefix and a string representation of a uuid.

  ### Example

      iex> {:ok, tid} = TypeID.from_uuid("device", "01890be9-b248-777e-964e-af1d244f997d")
      iex> tid
      #TypeID<"device_01h45ykcj8exz9cknf3mj4z6bx">

  """
  @spec from_uuid(prefix :: String.t(), uuid :: String.t()) :: {:ok, t()} | :error
  def from_uuid(prefix, uuid) do
    {:ok, from_uuid!(prefix, uuid)}
  rescue
    ArgumentError -> :error
  end

  @doc """
  Like `from_uuid_bytes/2` but raises an error if the `prefix` or `uuid_bytes`
  are invalid.
  """
  @spec from_uuid_bytes!(prefix :: String.t(), uuid_bytes :: binary()) :: t() | no_return()
  def from_uuid_bytes!(prefix, <<uuid_bytes::binary-size(16)>>) do
    suffix = Base32.encode(uuid_bytes)
    from!(prefix, suffix)
  end

  @doc """
  Parses a `t:t/0` from a prefix and a raw binary uuid.

  ### Example

      iex> {:ok, tid} = TypeID.from_uuid_bytes("policy", <<1, 137, 11, 235, 83, 221, 116, 212, 161, 42, 205, 139, 182, 243, 175, 110>>)
      iex> tid
      #TypeID<"policy_01h45ypmyxekaa2apdhevf7bve">

  """
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

  if Code.ensure_loaded?(Ecto.ParameterizedType) do
    use Ecto.ParameterizedType

    @impl Ecto.ParameterizedType
    def init(opts), do: validate_opts!(opts)

    @impl Ecto.ParameterizedType
    def type(%{type: type}), do: type

    @impl Ecto.ParameterizedType
    def autogenerate(%{prefix: prefix}) do
      new(prefix)
    end

    @impl Ecto.ParameterizedType
    def cast(nil, _params), do: {:ok, nil}
    def cast(%__MODULE__{prefix: prefix} = tid, %{prefix: prefix}), do: {:ok, tid}

    def cast(str, %{prefix: prefix}) when is_binary(str) do
      if String.starts_with?(str, prefix) do
        from_string(str)
      else
        with {:ok, uuid} <- Ecto.UUID.cast(str) do
          from_uuid(prefix, uuid)
        end
      end
    end

    def cast(_, _), do: :error

    @impl Ecto.ParameterizedType
    def dump(nil, _dumper, _params), do: {:ok, nil}

    def dump(%__MODULE__{prefix: prefix} = tid, _, %{prefix: prefix, type: :string}) do
      {:ok, __MODULE__.to_string(tid)}
    end

    def dump(%__MODULE__{prefix: prefix} = tid, _, %{prefix: prefix, type: :binary_id}) do
      {:ok, uuid(tid)}
    end

    def dump(_, _, _), do: :error

    @impl Ecto.ParameterizedType
    def load(nil, _, _), do: {:ok, nil}

    def load(str, _, %{type: :string, prefix: prefix}) do
      with {:ok, %__MODULE__{prefix: ^prefix}} = loaded <- from_string(str) do
        loaded
      end
    end

    def load(<<_::128>> = uuid, _, %{type: :binary_id, prefix: prefix}) do
      from_uuid_bytes(prefix, uuid)
    end

    def load(<<_::288>> = uuid, _, %{type: :binary_id, prefix: prefix}) do
      from_uuid(prefix, uuid)
    rescue
      _ -> :error
    end

    def load(_, _, _), do: :error

    defp validate_opts!(opts) do
      type = Keyword.get(opts, :type, :string)
      prefix = Keyword.get(opts, :prefix, "")

      unless prefix && prefix =~ ~r/^[a-z]{0,63}$/ do
        raise ArgumentError,
              "must specify `prefix` using only lowercase letters between 0 and 63 characters long."
      end

      unless type in ~w[string binary_id]a do
        raise ArgumentError, "`type` must be `:string` or `:binary_id`"
      end

      %{prefix: prefix, type: type}
    end
  end
end

defimpl Inspect, for: TypeID do
  import Inspect.Algebra

  def inspect(tid, _opts) do
    concat(["#TypeID<\"", TypeID.to_string(tid), "\">"])
  end
end
