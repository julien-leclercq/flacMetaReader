defmodule Vorbis do
  @moduledoc"""
    A module to provide parsing functions for Vorbis blocks
  """


  def read_block(packet) do
    {packet, %{}}
    |> read_vendor
    |> read_comments
  end

  def read_vendor({packet, vorbis}) do
    case packet do
      << vendor_length :: size(32)-little,
         vendor_string :: binary-size(vendor_length),
         comments::binary
      >> -> {
        << comments :: binary >>,
        Map.put(
          vorbis,
          :vendor,
          <<vendor_string::size(vendor_length)-unit(8)>>
        )
      }
    end
  end

  def read_comments({packet, vorbis}) do
    case packet do
      <<comments_length::size(32)-little, comments::binary>> ->
        read_comments({<<comments::binary>>, vorbis}, comments_length)
    end
  end

  def read_comments({comments, vorbis}, 1) do
    {_, final_vorbis} = read_comment({comments, vorbis})
    final_vorbis
  end

  def read_comments({comments, vorbis}, comments_length) do
    {comments, vorbis}
    |> read_comment
    |> read_comments(comments_length - 1)
  end

  def read_comment({comments, vorbis}) do
    case comments do
      <<
        comment_length::size(32)-little,
        comment::size(comment_length) - unit(8),
        ending::binary
      >> ->
        {
          <<ending::binary>>,
          parse_comment(<<comment::size(comment_length)-unit(8)>>, vorbis)
        }
    end
  end

  def parse_comment(comment, vorbis) do
    comment
    |> String.trim
    |> String.split("=")
    |> add_comment_value(vorbis)
  end

  def add_comment_value([key, value], vorbis) do
    down_key =
      key
      |> String.downcase
      |> String.to_atom
    Map.put(vorbis, down_key, [value | Map.get(vorbis, down_key)])
  end
end
