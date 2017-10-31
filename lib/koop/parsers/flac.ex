defmodule Koop.Parsers.Flac do
  alias Koop.Utils.Result
  alias Koop.Parsers.Vorbis
  import Result
  @behaviour Koop.Parser

  @moduledoc """
  Small library to parse and extract Flac files metadata
  """
  @doc """
    "664C6143" (Hexa) is the normal very beginning for every Flac file
  """
  @flac_header "fLaC"
  @vorbis_comment 4

  @spec hydrate(Koop.File.t, binary) :: Result.typed_result_tuple(Koop.File.t)
  def hydrate(koop_file, bytes) do
    bytes
    |> init_flac_meta_reading
    |> and_then(&read_metadatas(&1, koop_file))
  end

  @spec init_flac_meta_reading(binary) :: Result.typed_result_tuple(binary)
  def init_flac_meta_reading(bytes) do
    case bytes do
      (@flac_header <> tail) -> ok(tail)
      _ -> error("file is not valid FLAC")
    end
  end

  @doc """

  """

  @spec read_metadatas(binary, Koop.File.t) :: Result.typed_result_tuple(Koop.File.t)
  def read_metadatas(bits, koop_file) do
    << final           :: size(1),
       block_type      :: size(7),
       length          :: size(24),
       meta_data_block :: binary-size(length),
       ending          :: binary
    >> = bits

    res = case block_type do
      @vorbis_comment -> Vorbis.hydrate(koop_file, meta_data_block)
      _ -> koop_file
    end

    case final do
      1 -> ok(res)
      _ -> read_metadatas(<<ending::binary>>, res)
    end
  end

end
