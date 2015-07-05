-- DROP MATERIALIZED VIEW IF EXISTS simple_trajectories CASCADE;

CREATE MATERIALIZED VIEW simple_trajectories AS
  SELECT
    geom,
    identifier,
    tripnumber::int::varchar,
    dte::date,
    start_time::timestamp without time zone,
    start_time::timestamp without time zone + '00:00:01'::interval * duration as end_time,
    tripmot,
    mvpa

  FROM gps_trajectories_4326;