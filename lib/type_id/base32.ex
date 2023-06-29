defmodule TypeID.Base32 do
  import Bitwise

  crockford_alphabet = ~c"0123456789ABCDEFGHJKMNPQRSTVWXYZ"

  to_lower_enc = &Enum.map(&1, fn c -> if c in ?A..?Z, do: c - ?A + ?a, else: c end)
  to_lower_dec =
    &Enum.map(&1, fn {encoding, value} = pair ->
      if encoding in ?A..?Z do
        {encoding - ?A + ?a, value}
      else
        pair
      end
    end)

  lower = to_lower_enc.(crockford_alphabet)


  encoded = for e1 <- lower, e2 <- lower, do: bsl(e1, 8) + e2

  to_decode_list = fn alphabet ->
    alphabet = Enum.sort(alphabet)
    map = Map.new(alphabet)
    {min, _} = List.first(alphabet)
    {max, _} = List.last(alphabet)
    {min, Enum.map(min..max, &map[&1])}
  end

  {min, decoded} =
    lower
    |> Enum.with_index()
    |> to_lower_dec.()
    |> to_decode_list.()

  @spec encode(binary()) :: binary()
  def encode(data) when is_binary(data) do
    do_encode(data, "")
  end

  @spec decode(binary()) :: {:ok, binary()} | :error
  def decode(string) when is_binary(string) do
    {:ok, decode!(string)}
  rescue
    ArgumentError -> :error
  end

  @spec decode!(binary()) :: binary() | no_return()
  def decode!(string) when is_binary(string) do
    do_decode!(string)
  end

  @compile {:inline, [do_encode: 1]}
  defp do_encode(byte) do
    elem({unquote_splicing(encoded)}, byte)
  end

  defp do_encode(<<c1::10, c2::10, c3::10, c4::10, rest::binary>>, acc) do
    do_encode(
      rest,
      <<
        acc::binary,
        do_encode(c1)::16,
        do_encode(c2)::16,
        do_encode(c3)::16,
        do_encode(c4)::16
      >>
    )
  end

  defp do_encode(<<c1::10, c2::10, c3::10, c4::2>>, acc) do
    <<
      acc::binary,
      do_encode(c1)::16,
      do_encode(c2)::16,
      do_encode(c3)::16,
      c4 |> bsl(3) |> do_encode() |> band(0x00FF)::8
    >>
  end

  defp do_encode(<<c1::10, c2::10, c3::4>>, acc) do
    <<
      acc::binary,
      do_encode(c1)::16,
      do_encode(c2)::16,
      c3 |> bsl(1) |> do_encode() |> band(0x00FF)::8
    >>
  end

  defp do_encode(<<c1::10, c2::6>>, acc) do
    <<
      acc::binary,
      do_encode(c1)::16,
      c2 |> bsl(4) |> do_encode()::16
    >>
  end

  defp do_encode(<<c1::8>>, acc) do
    <<acc::binary, c1 |> bsl(2) |> do_encode()::16>>
  end

  defp do_encode(<<>>, acc) do
    acc
  end

  defp do_decode!(<<>>), do: <<>>

  defp do_decode!(string) when is_binary(string) do
    segs = div(byte_size(string) + 7, 8) - 1
    <<main::size(segs)-binary-unit(64), rest::binary>> = string

    main =
      for <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, c8::8 <- main>>, into: <<>> do
        <<
          do_decode!(c1)::5,
          do_decode!(c2)::5,
          do_decode!(c3)::5,
          do_decode!(c4)::5,
          do_decode!(c5)::5,
          do_decode!(c6)::5,
          do_decode!(c7)::5,
          do_decode!(c8)::5
        >>
      end

    case rest do
      <<c1::8, c2::8, ?=, ?=, ?=, ?=, ?=, ?=>> ->
        <<main::bits, do_decode!(c1)::5, bsr(do_decode!(c2), 2)::3>>

      <<c1::8, c2::8, c3::8, c4::8, ?=, ?=, ?=, ?=>> ->
        <<
          main::bits,
          do_decode!(c1)::5,
          do_decode!(c2)::5,
          do_decode!(c3)::5,
          bsr(do_decode!(c4), 4)::1
        >>

      <<c1::8, c2::8, c3::8, c4::8, c5::8, ?=, ?=, ?=>> ->
        <<
          main::bits,
          do_decode!(c1)::5,
          do_decode!(c2)::5,
          do_decode!(c3)::5,
          do_decode!(c4)::5,
          bsr(do_decode!(c5), 1)::4
        >>

      <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, ?=>> ->
        <<
          main::bits,
          do_decode!(c1)::5,
          do_decode!(c2)::5,
          do_decode!(c3)::5,
          do_decode!(c4)::5,
          do_decode!(c5)::5,
          do_decode!(c6)::5,
          bsr(do_decode!(c7), 3)::2
        >>

      <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, c8::8>> ->
        <<
          main::bits,
          do_decode!(c1)::5,
          do_decode!(c2)::5,
          do_decode!(c3)::5,
          do_decode!(c4)::5,
          do_decode!(c5)::5,
          do_decode!(c6)::5,
          do_decode!(c7)::5,
          do_decode!(c8)::5
        >>

      <<c1::8, c2::8>> ->
        <<main::bits, do_decode!(c1)::5, bsr(do_decode!(c2), 2)::3>>

      <<c1::8, c2::8, c3::8, c4::8>> ->
        <<
          main::bits,
          do_decode!(c1)::5,
          do_decode!(c2)::5,
          do_decode!(c3)::5,
          bsr(do_decode!(c4), 4)::1
        >>

      <<c1::8, c2::8, c3::8, c4::8, c5::8>> ->
        <<
          main::bits,
          do_decode!(c1)::5,
          do_decode!(c2)::5,
          do_decode!(c3)::5,
          do_decode!(c4)::5,
          bsr(do_decode!(c5), 1)::4
        >>

      <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8>> ->
        <<
          main::bits,
          do_decode!(c1)::5,
          do_decode!(c2)::5,
          do_decode!(c3)::5,
          do_decode!(c4)::5,
          do_decode!(c5)::5,
          do_decode!(c6)::5,
          bsr(do_decode!(c7), 3)::2
        >>
    end
  end

  defp do_decode!(char) do
    try do
      elem({unquote_splicing(decoded)}, char - unquote(min))
    rescue
      _ -> bad_character!(char)
    else
      nil -> bad_character!(char)
      char -> char
    end
  end

  defp bad_character!(byte) do
    raise ArgumentError,
          "non-alphabet character found: #{inspect(<<byte>>, binaries: :as_strings)} (byte #{byte})"
  end
end
