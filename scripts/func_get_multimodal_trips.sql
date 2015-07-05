-- DROP MATERIALIZED VIEW IF EXISTS multi_modal_trips CASCADE;
-- DROP FUNCTION getMultiModalTrips();
-- DROP TYPE multi_modal_trip;

CREATE TYPE multi_modal_trip AS (
  geom geometry,
  identifier VARCHAR,
  start_time timestamp without time zone,
  end_time timestamp without time zone,
  duration interval,
  -- movement_duration interval,
  number_of_segments int8,
  mvpa_sum float,
  mmt_number int8,
  segment_order varchar,
  segment_ids varchar
);

-- --
-- getMultiModalTrips(p geometry, )
-- --
CREATE OR REPLACE FUNCTION getMultiModalTrips()
  RETURNS SETOF multi_modal_trip AS
  $BODY$DECLARE

    m int8;
    ms multi_modal_trip_segment_type_with_guid;

    so varchar := '';
    sids varchar := '';

    mmtr multi_modal_trip;
    sum_mvpa float;
    n_segments int2 := 0;
    start_time timestamp without time zone := null;
    end_time timestamp without time zone;
    dur interval;
    gg geometry[];

  BEGIN

    FOR m IN SELECT mmt_number FROM mm_trip_segment_numbers LOOP

      gg := array[]::geometry[];
      sum_mvpa := 0;
      so := '';
      sids := '';
      n_segments := 0;
      start_time := null;

      FOR ms IN SELECT * FROM mm_trip_segments WHERE mmt_number=m LOOP

        IF start_time is null THEN

          start_time = ms.start_time;
          -- gg := array[ms.geom]::geometry[];
        ELSE

        END IF;

        gg := array_append(gg, ST_LineMerge(ms.geom));

        so := so || ms.tripmot::int2::varchar || '-';
        sids := sids || ms.mms_guid || '-';

        mmtr.identifier := ms.identifier;
        sum_mvpa := sum_mvpa + ms.mvpa;
        n_segments := n_segments +1;

        end_time := ms.end_time;

      END LOOP;

      so := left(so, length(so)-1);
      sids := left(sids, length(sids)-1);

      mmtr.segment_order := so;
      mmtr.mvpa_sum:=sum_mvpa;
      mmtr.mmt_number:=m;
      mmtr.number_of_segments := n_segments;
      mmtr.start_time := start_time;
      mmtr.end_time := end_time;
      mmtr.duration := end_time-start_time;
      mmtr.geom := ST_SetSRID(ST_Makeline(gg), 4326);
      mmtr.segment_ids := sids;

      RETURN NEXT mmtr;

    END LOOP;

    RETURN;

  END;$BODY$
LANGUAGE plpgsql VOLATILE
COST 1;

CREATE MATERIALIZED VIEW multi_modal_trips AS
  SELECT
    *
  FROM getMultiModalTrips();