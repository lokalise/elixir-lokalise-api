defmodule ElixirLokaliseApi.SegmentsTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  alias ElixirLokaliseApi.Segments
  alias ElixirLokaliseApi.Model.Segment, as: SegmentModel
  alias ElixirLokaliseApi.Collection.Segments, as: SegmentsCollection

  setup_all do
    HTTPoison.start()
  end

  doctest Segments

  @project_id "39066161618d4ecb9fdc12.00274309"
  @key_id 129_358_815
  @lang_iso "en"

  test "find a segment" do
    use_cassette "segment_find" do
      {:ok, %SegmentModel{} = segment} = Segments.find(@project_id, @key_id, @lang_iso, 1)
      assert segment.segment_number == 1
      assert segment.language_iso == @lang_iso
      assert segment.modified_at == "2021-11-22 16:25:54 (Etc/UTC)"
      assert segment.modified_at_timestamp == 1_637_598_354
      assert segment.modified_by == 20181
      assert segment.modified_by_email == "bodrovis@protonmail.com"
      assert segment.value == "Hello!"
      refute segment.is_fuzzy
      refute segment.is_reviewed
      assert segment.reviewed_by == 0
      assert segment.words == 1
      assert segment.custom_translation_statuses == []
    end
  end

  test "find a segment with params" do
    use_cassette "segment_find_params" do
      {:ok, %SegmentModel{} = segment} =
        Segments.find(@project_id, @key_id, @lang_iso, 2, disable_references: 1)

      assert segment.segment_number == 2
      assert segment.language_iso == @lang_iso
    end
  end

  test "list all segments" do
    use_cassette "segments_all" do
      {:ok, %SegmentsCollection{} = segments} = Segments.all(@project_id, @key_id, @lang_iso)
      assert segments.project_id == @project_id
      assert segments.key_id == @key_id
      assert segments.language_iso == @lang_iso
      segment = hd(segments.items)
      assert segment.value == "Hello!"
    end
  end

  test "list all segments with params" do
    use_cassette "segments_all_params" do
      {:ok, %SegmentsCollection{} = segments} =
        Segments.all(@project_id, @key_id, @lang_iso,
          disable_references: 1,
          filter_untranslated: 0
        )

      assert segments.project_id == @project_id
      segment = hd(segments.items)
      assert segment.value == "Hello!"
    end
  end

  test "update a segment" do
    use_cassette "segment_update" do
      segment_data = %{value: "Sample text from Elixir", is_reviewed: true}

      {:ok, %SegmentModel{} = segment} =
        Segments.update(@project_id, @key_id, @lang_iso, 2, segment_data)

      assert segment.segment_number == 2
      assert segment.language_iso == @lang_iso
      assert segment.value == "Sample text from Elixir"
      assert segment.is_reviewed
      status = hd(segment.custom_translation_statuses)
      assert status[:title] == "context"
    end
  end
end
