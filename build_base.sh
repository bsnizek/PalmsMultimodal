#!/usr/bin/env bash

psql -f scripts/drop_everything.sql tom
psql -f scripts/view_identifiers.sql tom
psql -f scripts/view_simple_trajectories.sql tom
psql -f scripts/view_days.sql tom
psql -f scripts/func_get_multimodal_trip_segments.sql tom
psql -f scripts/view_multimodal_trip_segments.sql tom
psql -f scripts/view_mm_trip_segment_numbers.sql tom
psql -f scripts/func_get_multimodal_trips.sql tom
# psql -f scripts/view_multi_modal_trips.sql tom

pgsql2shp -f results/multimodal_trips.shp tom multi_modal_trips