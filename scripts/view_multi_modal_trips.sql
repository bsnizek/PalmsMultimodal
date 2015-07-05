-- DROP MATERIALIZED VIEW IF EXISTS multi_modal_trips CASCADE;
-- DROP SEQUENCE multi_modal_trip_guid_seq;

CREATE SEQUENCE multi_modal_trip_guid_seq START 1;

CREATE MATERIALIZED VIEW multi_modal_trips AS
  SELECT
    nextval('multi_modal_trip_guid_seq') AS mm_guid,
    *
  FROM getMultiModalTrips();