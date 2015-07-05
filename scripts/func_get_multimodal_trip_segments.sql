-- DROP FUNCTION getMultiModalTripSegments();
-- DROP TYPE multi_modal_trip_segment_type;

CREATE TYPE multi_modal_trip_segment_type AS (
  geom geometry,
  identifier VARCHAR,
  start_time timestamp without time zone,
  end_time timestamp without time zone,
  duration interval,
  dte date,
  tripmot int2,
  mvpa float,
  mmt_number int8
);

CREATE TYPE multi_modal_trip_segment_type_with_guid AS (
  mms_guid int8,
  geom geometry,
  identifier VARCHAR,
  start_time timestamp without time zone,
  end_time timestamp without time zone,
  duration interval,
  dte date,
  tripmot int2,
  mvpa float,
  mmt_number int8
);

-- --
-- getMultiModalTrips(p geometry, )
-- --
CREATE OR REPLACE FUNCTION getMultiModalTripSegments()
  RETURNS SETOF multi_modal_trip_segment_type AS
  $BODY$DECLARE

    r record;
    p multi_modal_trip_segment_type;
    u varchar;
    d date;
    last_end_time timestamp WITHOUT TIME ZONE := null;
    last_geom geometry := null;
    mmt int8 := 1;
    ep geometry;
    fp geometry;
    di float;

  BEGIN

    FOR u IN SELECT identifier FROM identifiers LOOP

      FOR d IN SELECT dte FROM days LOOP

        FOR r IN SELECT * FROM simple_trajectories WHERE identifier = u AND dte = d LOOP

          IF last_end_time = null THEN

          -- we are in the first segment

          ELSE

            ep := ST_Endpoint(ST_LineMerge(last_geom));
            fp := ST_Startpoint(ST_LineMerge(r.geom));
            di := ST_Distance(ep::geography, fp::geography);

--             RAISE INFO '%', di;

            IF (r.end_time - last_end_time < interval '00:10:00') AND (di < 200) THEN
            -- we have a connection
            ELSE
              -- no connection
              mmt := mmt + 1;

            END IF;


          END IF;

          last_end_time := r.end_time;
          last_geom := r.geom;

          p.geom := ST_SetSRID(r.geom, 4326);
          p.geom := r.geom;
          p.identifier := r.identifier;
          p.start_time := r.start_time;
          p.end_time := r.end_time;
          p.duration := r.end_time - r.start_time;
          p.dte := r.dte;
          p.tripmot := r.tripmot::int2;
          p.mvpa := r.mvpa;

          p.mmt_number := mmt;

          RETURN NEXT p;


        END LOOP;

      END LOOP;

    END LOOP;

    RETURN;

  END;$BODY$
LANGUAGE plpgsql VOLATILE
COST 1;