defmodule FlacMetaReader do

  @moduledoc """
  Small library to parse and extract Flac files metadata
  """
  @flac_header <<0x66, 0x4C, 0x61, 0x43>>
  @vorbis_comment 4

  def read(file) do
    File.open(file)
    |> init_flac_meta_reading
  end

  @doc """
    await a couple atom, PID the PID being the file descriptor of
    the subject track
  """
  def init_flac_meta_reading({:error, reason}),  do: {:error, reason}
  def init_flac_meta_reading({:ok, io_device}) do
    cond IO.binread(io_device, :all) do
      @flac_header <> tail -> {:ok, tail}
      _ -> {:error, 'file is not valid FLAC'}
    end
  end

  @doc """

  """
  def read_metadatas(bits), do: read_metadatas(bits, %{})
  def read_metadatas(bits, metadatas) do
    <<
      final::size(1),
      block_type::size(7),
      length::size(24),
      meta_data_block::size(length)-unit(8),
      ending::binary
    >> = bits

    res = case block_type do
      @vorbis_comment ->
        Map.put(
          metadatas,
          :vorbis,
          Vorbis.read_block(<<meta_data_block::size(length)-unit(8)>>)
        )
      _ -> metadatas
    end

    cond final do
      1 -> res
      _ -> read_metadatas(<<ending::binary>>, res)
    end
  end

end
