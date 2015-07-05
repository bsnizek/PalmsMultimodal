-- --
--

CREATE MATERIALIZED VIEW identifiers AS
  SELECT identifier
  from gps_trajectories_4326
  GROUP BY identifier
  ORDER BY identifier ASC;