-- DROP MATERIALIZED VIEW IF EXISTS mm_trip_segments CASCADE;
-- DROP SEQUENCE multi_modal_trip_segment_guid_seq;

CREATE SEQUENCE multi_modal_trip_segment_guid_seq START 1;

CREATE MATERIALIZED VIEW mm_trip_segments AS
  SELECT

    nextval('multi_modal_trip_segment_guid_seq') AS mms_guid,
    *

  FROM getMultiModalTripSegments();