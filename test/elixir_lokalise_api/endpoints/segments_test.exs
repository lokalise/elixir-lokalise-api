defmodule ElixirLokaliseApi.SegmentsTest do
  use ElixirLokaliseApi.Case, async: true

  alias ElixirLokaliseApi.Segments
  alias ElixirLokaliseApi.Model.Segment, as: SegmentModel
  alias ElixirLokaliseApi.Collection.Segments, as: SegmentsCollection

  doctest Segments

  @project_id "39066161618d4ecb9fdc12.00274309"
  @key_id 129_358_815
  @lang_iso "en"

  test "find a segment" do
    segment_number = 2

    response = %{
      project_id: @project_id,
      key_id: @key_id,
      language_iso: @lang_iso,
      segment: %{
        segment_number: segment_number,
        language_iso: @lang_iso,
        value: "This is just a simple text.",
        modified_by: 20181,
        modified_by_email: "user@example.com",
        modified_at: "2021-11-22 16:46:50 (Etc/UTC)",
        modified_at_timestamp: 1_637_599_610,
        is_reviewed: false,
        reviewed_by: 0,
        is_fuzzy: false,
        words: 6,
        custom_translation_statuses: [
          %{
            status_id: 5734,
            title: "context",
            color: "#61bd4f"
          }
        ]
      }
    }

    params = [disable_references: 1]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method(
        "/api2/projects/#{@project_id}/keys/#{@key_id}/segments/#{@lang_iso}/#{segment_number}"
      )

      req
      |> assert_get_params(params)

      response
      |> ok()
    end)

    {:ok, %SegmentModel{} = segment} =
      Segments.find(@project_id, @key_id, @lang_iso, segment_number, params)

    assert segment.segment_number == segment_number
    assert segment.language_iso == @lang_iso
    assert segment.modified_at == "2021-11-22 16:46:50 (Etc/UTC)"
    assert segment.modified_at_timestamp == 1_637_599_610
    assert segment.modified_by == 20181
    assert segment.modified_by_email == "user@example.com"
    assert segment.value == "This is just a simple text."
    refute segment.is_fuzzy
    refute segment.is_reviewed
    assert segment.reviewed_by == 0
    assert segment.words == 6

    status = segment.custom_translation_statuses |> hd
    assert status.title == "context"
  end

  test "list all segments" do
    segments =
      for i <- 1..3 do
        %{
          segment_number: 100 + i,
          language_iso: @lang_iso,
          value: "Segment #{i}"
        }
      end

    response = %{
      project_id: @project_id,
      key_id: @key_id,
      language_iso: @lang_iso,
      segments: segments
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/keys/#{@key_id}/segments/#{@lang_iso}")

      response
      |> ok()
    end)

    {:ok, %SegmentsCollection{} = segments} = Segments.all(@project_id, @key_id, @lang_iso)
    assert segments.project_id == @project_id
    assert segments.key_id == @key_id
    assert segments.language_iso == @lang_iso
    segment = hd(segments.items)
    assert segment.value == "Segment 1"
  end

  test "list all segments with params" do
    segments =
      for i <- 1..3 do
        %{
          segment_number: 100 + i,
          language_iso: @lang_iso,
          value: "Segment #{i}"
        }
      end

    response = %{
      project_id: @project_id,
      key_id: @key_id,
      language_iso: @lang_iso,
      segments: segments
    }

    params = [disable_references: 1, filter_untranslated: 0]

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method("/api2/projects/#{@project_id}/keys/#{@key_id}/segments/#{@lang_iso}")

      req
      |> assert_get_params(params)

      response
      |> ok()
    end)

    {:ok, %SegmentsCollection{} = segments} =
      Segments.all(@project_id, @key_id, @lang_iso, params)

    assert segments.project_id == @project_id
    segment = hd(segments.items)
    assert segment.value == "Segment 1"
  end

  test "update a segment" do
    segment_number = 2
    segment_data = %{value: "Sample text from Elixir", is_reviewed: true}

    response = %{
      project_id: @project_id,
      key_id: @key_id,
      language_iso: @lang_iso,
      segment: %{
        segment_number: segment_number,
        language_iso: @lang_iso,
        value: "Sample text from Elixir",
        is_reviewed: true
      }
    }

    ElixirLokaliseApi.HTTPClientMock
    |> expect(:request, fn req, _finch_name, _opts ->
      req
      |> assert_path_method(
        "/api2/projects/#{@project_id}/keys/#{@key_id}/segments/#{@lang_iso}/#{segment_number}",
        "PUT"
      )

      req |> assert_json_body(segment_data)

      response
      |> ok()
    end)

    {:ok, %SegmentModel{} = segment} =
      Segments.update(@project_id, @key_id, @lang_iso, segment_number, segment_data)

    assert segment.segment_number == segment_number
    assert segment.language_iso == @lang_iso
    assert segment.value == "Sample text from Elixir"
    assert segment.is_reviewed
  end
end
