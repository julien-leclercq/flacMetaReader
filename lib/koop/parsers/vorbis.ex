defmodule Koop.Parsers.Vorbis do
  alias Koop.Utils.Result
  import Result

  @moduledoc"""
    A module to provide parsing functions for Vorbis blocks
  """
  @behaviour Koop.Parser

  @spec hydrate(Koop.File.t, binary) :: Result.typed_result_tuple(Koop.File.t)
  def hydrate(%Koop.File{} = koop_file, block) when is_binary(block) do
    {koop_file, block}
    |> read_vendor
    |> and_then(&read_comments/1)
  end

  @spec read_vendor({Koop.File.t, binary}) :: Result.typed_result_tuple({Koop.File.t, binary})
  defp read_vendor({%Koop.File{} = koop_file, packet}) when is_binary(packet) do
    case packet do
      << vendor_length :: size(32)-little,
         vendor_string :: binary-size(vendor_length),
         comments::binary
      >> -> ok({
        Koop.File.set_vendor(koop_file, vendor_string),
        << comments :: binary >>
      })
    end
  end

  @spec read_comments({Koop.File.t, binary}) :: Result.typed_result_tuple(Koop.File.t)
  defp read_comments({koop_file, packet}) do
    case packet do
      <<comments_length::size(32)-little, comments::binary>> ->
        read_comments({koop_file, <<comments::binary>>}, comments_length)
    end
  end

  @spec read_comments({Koop.File.t, binary}, integer) :: Result.typed_result_tuple(Koop.File.t)
  defp read_comments({koop_file, _packet}, 0), do: ok(koop_file)
  defp read_comments({koop_file, comments}, comments_length) do
    {koop_file, comments}
    |> read_comment
    |> and_then(&read_comments(&1, comments_length - 1))
  end

  @spec read_comment({Koop.File.t, binary}) :: Result.typed_result_tuple({Koop.File.t, binary})
  defp read_comment({koop_file, comments}) do
    case comments do
      <<
        comment_length::size(32)-little,
        comment::binary - size(comment_length),
        ending::binary
      >> ->
        koop_file
        |> parse_comment(comment)
        |> map(&{&1, <<ending::binary>>})

    end
  end

  @spec parse_comment(Koop.File.t, binary) :: Result.typed_result_tuple(Koop.File.t)
  defp parse_comment(koop_file, comment) do
    comment
    |> String.trim
    |> String.split("=")
    |> fn [key, value] -> {key, value} end.()
    |> add_comment_value(koop_file)
    |> ok
  end

  @spec add_comment_value({String.t, String.t}, Koop.File.t) :: Koop.File.t
  defp add_comment_value({key, value}, %Koop.File{} = koop_file) do
    updater = case key do
      "TITLE"        -> &Koop.Track.set_title/2
      "TRACKNUMBER"  -> &Koop.Track.set_tracknumber/2
      "ALBUM"        -> &Koop.Track.set_album/2
      "ARTIST"       -> &Koop.Track.add_artist/2
      "ALBUMARTIST"  -> &Koop.Track.add_albumartist/2
      "VERSION"      -> &Koop.Track.set_version/2
      "PERFORMER"    -> &Koop.Track.add_performer/2
      "COPYRIGHT"    -> &Koop.Track.add_copyright/2
      "LICENCE"      -> &Koop.Track.add_licence/2
      "ORGANIZATION" -> &Koop.Track.add_organization/2
      "DESCRIPTION"  -> &Koop.Track.add_description/2
      "DATE"         -> &Koop.Track.set_date/2
      "LOCATION"     -> &Koop.Track.add_location/2
      "CONTACT"      -> &Koop.Track.add_contact/2
      "ISRC"         -> &Koop.Track.add_isrc/2
    end

    track_updater = fn track -> updater.(track, value) end
    Koop.File.update_track(koop_file, track_updater)
  end

end
