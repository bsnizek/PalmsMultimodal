#!/usr/bin/env bash

# shp2pgsql -s 900913 gis_data/experience_points_raw public.experience_points_raw > sql_data/experience_points_raw.sql
# shp2pgsql -s 900913 gis_data/routes public.routes > sql_data/routes.sql

shp2pgsql -s 900913 gis_data/GCS_WGS_1984/At_Home_Buffers_GCS_WGS_1984.shp                  >sql_data/At_Home_Buffers_GCS_WGS_1984.sql
shp2pgsql -s 4326   gis_data/GCS_WGS_1984/GPS_Trajectories_4326.shp                         >sql_data/GPS_Trajectories_4326.sql
shp2pgsql -s 900913 gis_data/GCS_WGS_1984/North_Island_Road_Centerlines_GCS_WGS_1984.shp    >sql_data/North_Island_Road_Centerlines_GCS_WGS_1984.sql
shp2pgsql -s 900913 gis_data/GCS_WGS_1984/Schoolyard_Polygons_GCS_WGS_1984.shp              >sql_data/Schoolyard_Polygons_GCS_WGS_1984.sql
shp2pgsql -s 900913 gis_data/GCS_WGS_1984/Shortest_GIS_Route_GCS_WGS_1984.shp               >sql_data/Shortest_GIS_Route_GCS_WGS_1984.sql
shp2pgsql -s 900913 gis_data/GCS_WGS_1984/VERITAS_Route_GCS_WGS_1984.shp                    >sql_data/VERITAS_Route_GCS_WGS_1984.sql


psql -f sql_data/At_Home_Buffers_GCS_WGS_1984.sql tom
psql -f sql_data/GPS_Trajectories_4326.sql tom
psql -f sql_data/North_Island_Road_Centerlines_GCS_WGS_1984.sql tom
psql -f sql_data/Schoolyard_Polygons_GCS_WGS_1984.sql tom
psql -f sql_data/Shortest_GIS_Route_GCS_WGS_1984.sql tom
psql -f sql_data/VERITAS_Route_GCS_WGS_1984.sql tom