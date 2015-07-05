-- --
-- DROP MATERIALIZED VIEW IF EXISTS mm_trip_segment_numbers CASCADE;

CREATE MATERIALIZED VIEW mm_trip_segment_numbers AS
  SELECT mmt_number
  from mm_trip_segments
  GROUP BY mmt_number
  ORDER BY mmt_number ASC;