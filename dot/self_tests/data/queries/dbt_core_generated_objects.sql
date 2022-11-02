-- these are generated the db objects generated by `test_run_dot_tests`

CREATE OR REPLACE VIEW self_tests_public_tests.dot_model__airlines_data
AS SELECT DISTINCT flight_data.airline
   FROM self_tests_public.flight_data;

CREATE OR REPLACE VIEW self_tests_public_tests.chv_tr_different_dot_model__all_flight_data_price_distribution
AS SELECT dot_model__airlines_data.airline,
    failed.failed
   FROM self_tests_public_tests.dot_model__airlines_data
     JOIN unnest(ARRAY['British Airways'::text]) failed(failed) ON failed.failed = dot_model__airlines_data.airline::text;

CREATE OR REPLACE VIEW self_tests_public_tests.dot_model__all_airports_data
AS SELECT airport_data.uuid,
    airport_data.airport,
    airport_data.airport_iata
   FROM self_tests_public.airport_data;

CREATE OR REPLACE VIEW self_tests_public_tests.dot_model__all_flight_data
AS SELECT flight_data.uuid,
    flight_data.departure_time,
    flight_data.airline,
    flight_data.origin_airport,
    flight_data.origin_iata,
    flight_data.destination_airport,
    flight_data.destination_iata,
    flight_data.stops,
    flight_data.price
   FROM self_tests_public.flight_data;

CREATE OR REPLACE VIEW self_tests_public_tests.dot_model__ethiopia_airlines_data
AS SELECT flight_data.uuid,
    flight_data.departure_time,
    flight_data.airline,
    flight_data.origin_airport,
    flight_data.origin_iata,
    flight_data.destination_airport,
    flight_data.destination_iata,
    flight_data.stops,
    flight_data.price
   FROM self_tests_public.flight_data
  WHERE flight_data.airline::text = 'Ethiopian Airlines'::text;

CREATE OR REPLACE VIEW self_tests_public_tests.dot_model__zagreb_flight_data
AS SELECT flight_data.uuid,
    flight_data.departure_time,
    flight_data.airline,
    flight_data.origin_airport,
    flight_data.origin_iata,
    flight_data.destination_airport,
    flight_data.destination_iata,
    flight_data.stops,
    flight_data.price
   FROM self_tests_public.flight_data
  WHERE flight_data.origin_airport::text = 'Zagreb airport'::text;

CREATE OR REPLACE VIEW self_tests_public_tests.tr_dot_model__all_airports_data_unique_airport
AS SELECT dot_model__all_airports_data.airport AS unique_field,
    count(*) AS n_records
   FROM self_tests_public_tests.dot_model__all_airports_data
  WHERE dot_model__all_airports_data.airport IS NOT NULL
  GROUP BY dot_model__all_airports_data.airport
 HAVING count(*) > 1;

CREATE OR REPLACE VIEW self_tests_public_tests.tr_dot_model__all_flight_data_accepted_values_stops
AS WITH all_values AS (
         SELECT dot_model__all_flight_data.stops AS value_field,
            count(*) AS n_records
           FROM self_tests_public_tests.dot_model__all_flight_data
          GROUP BY dot_model__all_flight_data.stops
        )
 SELECT all_values.value_field,
    all_values.n_records
   FROM all_values
  WHERE all_values.value_field::text <> ALL (ARRAY['1'::character varying, '2'::character varying, '3'::character varying, 'Non-stop'::character varying]::text[]);

CREATE OR REPLACE VIEW self_tests_public_tests.tr_dot_model__all_flight_data_flight_with_no_a
AS SELECT array_agg(from_model.from_uuid) AS uuid_list
   FROM ( SELECT dot_model__all_flight_data.uuid AS from_uuid,
            dot_model__all_flight_data.origin_airport AS from_column_id
           FROM self_tests_public_tests.dot_model__all_flight_data) from_model
     LEFT JOIN ( SELECT dot_model__all_airports_data.airport AS to_id
           FROM self_tests_public_tests.dot_model__all_airports_data) to_model ON to_model.to_id::text = from_model.from_column_id::text
  WHERE from_model.from_column_id IS NOT NULL AND to_model.to_id IS NULL
 HAVING count(*) > 0;

CREATE OR REPLACE VIEW self_tests_public_tests.tr_dot_model__all_flight_data_not_null_origin_a
AS SELECT dot_model__all_flight_data.uuid,
    dot_model__all_flight_data.departure_time,
    dot_model__all_flight_data.airline,
    dot_model__all_flight_data.origin_airport,
    dot_model__all_flight_data.origin_iata,
    dot_model__all_flight_data.destination_airport,
    dot_model__all_flight_data.destination_iata,
    dot_model__all_flight_data.stops,
    dot_model__all_flight_data.price
   FROM self_tests_public_tests.dot_model__all_flight_data
  WHERE dot_model__all_flight_data.origin_airport IS NULL;

CREATE OR REPLACE VIEW self_tests_public_tests.tr_dot_model__all_flight_data_price
AS SELECT array_agg(dot_model__all_flight_data.uuid) AS uuid_list
   FROM self_tests_public_tests.dot_model__all_flight_data
  WHERE dot_model__all_flight_data.price::character varying::text ~~ '-%'::text
 HAVING count(*) > 0;
