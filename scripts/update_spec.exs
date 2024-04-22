#!/usr/bin/env -S ERL_FLAGS=+B elixir

Mix.install(req: "~> 0.4")

files = [
  {"https://raw.githubusercontent.com/jetpack-io/typeid/main/spec/invalid.yml", "priv/spec/invalid.yml"},
  {"https://raw.githubusercontent.com/jetpack-io/typeid/main/spec/valid.yml", "priv/spec/valid.yml"}
]

IO.puts("Updating spec YAML files")

:ok = for {src, dest} <- files, reduce: :ok do
  :ok ->
    IO.write("Downloading #{src} to #{dest}... ")
    with {:ok, io} <- File.open(dest, [:write]),
      {:ok, _} <- Req.get(src, into: IO.binstream(io, 500)) do
      IO.puts("OK")
      :ok
    else
      other ->
        IO.puts("ERROR")
        other
    end
  failure -> failure
end

IO.puts("Done!")
