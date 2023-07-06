defmodule TypeID.Base32 do
  @moduledoc false

  # Implements base 32 encoding using the a lowercase crockford alphabet
  # https://www.crockford.com/base32.html

  crockford_alphabet = ~c"0123456789abcdefghjkmnpqrstvwxyz"

  @spec encode(binary()) :: binary()
  def encode(
        <<c1::3, c2::5, c3::5, c4::5, c5::5, c6::5, c7::5, c8::5, c9::5, c10::5, c11::5, c12::5,
          c13::5, c14::5, c15::5, c16::5, c17::5, c18::5, c19::5, c20::5, c21::5, c22::5, c23::5,
          c24::5, c25::5, c26::5>>
      ) do
    <<do_encode(c1)::8, do_encode(c2)::8, do_encode(c3)::8, do_encode(c4)::8, do_encode(c5)::8,
      do_encode(c6)::8, do_encode(c7)::8, do_encode(c8)::8, do_encode(c9)::8, do_encode(c10)::8,
      do_encode(c11)::8, do_encode(c12)::8, do_encode(c13)::8, do_encode(c14)::8,
      do_encode(c15)::8, do_encode(c16)::8, do_encode(c17)::8, do_encode(c18)::8,
      do_encode(c19)::8, do_encode(c20)::8, do_encode(c21)::8, do_encode(c22)::8,
      do_encode(c23)::8, do_encode(c24)::8, do_encode(c25)::8, do_encode(c26)::8>>
  end

  def encode(_), do: :error

  @spec decode(binary()) :: {:ok, binary()} | :error
  def decode(string) when is_binary(string) do
    {:ok, decode!(string)}
  rescue
    ArgumentError -> :error
  end

  @spec decode!(binary()) :: binary() | no_return()
  def decode!(
        <<c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16, c17, c18, c19,
          c20, c21, c22, c23, c24, c25, c26>>
      )
      when c1 in ?0..?7 do
    <<do_decode(c1)::3, do_decode(c2)::5, do_decode(c3)::5, do_decode(c4)::5, do_decode(c5)::5,
      do_decode(c6)::5, do_decode(c7)::5, do_decode(c8)::5, do_decode(c9)::5, do_decode(c10)::5,
      do_decode(c11)::5, do_decode(c12)::5, do_decode(c13)::5, do_decode(c14)::5,
      do_decode(c15)::5, do_decode(c16)::5, do_decode(c17)::5, do_decode(c18)::5,
      do_decode(c19)::5, do_decode(c20)::5, do_decode(c21)::5, do_decode(c22)::5,
      do_decode(c23)::5, do_decode(c24)::5, do_decode(c25)::5, do_decode(c26)::5>>
  end

  def decode!(_) do
    raise ArgumentError, "invalid base 32 suffix"
  end

  @compile {:inline, [do_encode: 1]}
  defp do_encode(byte) do
    elem({unquote_splicing(crockford_alphabet)}, byte)
  end

  for {char, byte} <- Enum.with_index(crockford_alphabet) do
    defp do_decode(unquote(char)), do: unquote(byte)
  end

  defp do_decode(char), do: bad_character!(char)

  defp bad_character!(byte) do
    raise ArgumentError,
          "non-alphabet character found: #{inspect(<<byte>>, binaries: :as_strings)} (byte #{byte})"
  end
end
