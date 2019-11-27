-- Connect to DBMS instance using 'psql -U bala'
-- The sample land registry data is from http://prod.publicdata.landregistry.gov.uk.s3-website-eu-west-1.amazonaws.com/pp-complete.csv
-- You can load the data into a database as described here - https://wiki.postgresql.org/wiki/Sample_Databases
-- The sample dvd rental data is from http://www.postgresqltutorial.com/postgresql-sample-database/

-- List databases
\l

-- Connect to land_registry database
\c lang_registry

-- List the tables
\dt

-- Describe the price_paid table
\d price_paid

-- Get the number of records in the table.
select count(*) 
  from price_paid;

-- Get 10 records from the price_paid table
select * 
  from price_paid 
  limit 10;

-- Select only three columns of the 10 records
select transfer_date, county, price 
  from price_paid 
  limit 10;

-- Select only the records for the year 1995
select county, price 
  from price_paid 
  where extract(year from transfer_date) = 1995;

-- Get top 20 counties in UK in 1995 in terms of the average price
select county, avg(price) as avg_price 
  from price_paid 
  where  extract(year from transfer_date) = 1995
  group by county
  order by avg_price desc
  limit 20;

-- Get top 20 counties in UK in 2018 in terms of the average price
select county, avg(price) as avg_price 
  from price_paid
  where  extract(year from transfer_date) = 2018
  group by county
  order by avg_price desc
  limit 20;

-- Get all records for one single day
select * 
  from price_paid 
  where transfer_date = '1995-12-04';

-- Show how long the query takes
explain analyse 
select * 
  from price_paid
  where transfer_date = '1995-12-04';

-- Remove the index on the transfer date column
drop index price_paid_transfer_date_idx;

-- Show the time take by the same query after removing the index
explain analyse select * from price_paid where transfer_date = '1995-12-04';

-- Connect to dvd_rentals database
\c dvd_rentals

-- List all the tables
\dt

-- Show 10 records from customer table
select * 
  from customer 
  limit 10;

-- Show 10 records from rentals table
select *
  from rental
  limit 10;

-- Get the top 10 cutomers in terms of number of times they rented.
select concat(first_name,' ',last_name) as name,count(*) rentals 
  from rental 
  left join customer 
    on rental.customer_id=customer.customer_id 
  group by 1 
  order by 2 desc 
  limit 10;

-- Get the top 20 biggest associations between actors and customers.
select * 
  from (
    select 
      concat(customer.first_name,' ',customer.last_name) as customer, 
      concat(actor.first_name,' ',actor.last_name) as actor, 
      count(*) as watched 
    from rental
    left join customer
      on rental.customer_id=customer.customer_id 
    left join inventory
      on rental.inventory_id = inventory.inventory_id 
    left join film 
      on inventory.film_id = film.film_id 
    full join film_actor 
      on film.film_id = film_actor.film_id
    left join actor 
      on film_actor.actor_id = actor.actor_id 
    where customer is not null and actor is not null 
    group by 1,2 
    order by 1,2
  ) as watch_counts 
  order by watched desc
  limit 20;
