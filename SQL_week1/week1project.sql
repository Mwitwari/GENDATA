create database Somalia;

use Somalia;




drop table village_location;
drop table jurisdiction_hierarchy;
drop table beneficiary_partner_data;

CREATE TABLE village_location (
    village_id INT AUTO_INCREMENT PRIMARY KEY,
    village_name VARCHAR(100),
    district_id INT,
    latitude DECIMAL(10, 7),
    longitude DECIMAL(10, 7)
);


CREATE TABLE jurisdiction_hierarchy (
    district_id INT AUTO_INCREMENT PRIMARY KEY,
    district_name VARCHAR(100),
    region_name VARCHAR(100),
    district_population INT
);


CREATE TABLE beneficiary_partner_data (
    partner_id INT AUTO_INCREMENT PRIMARY KEY,
    partner_name VARCHAR(100),
    village_id INT,
    beneficiaries INT,
    beneficiary_type VARCHAR(50),
    FOREIGN KEY (village_id) REFERENCES village_location(village_id)
);



insert into village_location (village_name, district_id, latitude, longitude) values
('Nairobi', 1, 2.034, 45.323),
('Kisumu', 1, 2.041, 45.310),
('Thika', 2, 4.183, 45.322),
('Utawala', 3, 5.333, 45.347),
('Kamulu', 3, 6.555, 45.8880);

insert into jurisdiction_hierarchy (district_id, district_name, region_name, district_population) values
(1, 'Embakasi', 'Umoja', 50000),
(2,'Bondo', 'Dagoretti', 80000),
(3, 'Mihango', 'Kasarani', 90000);

insert into beneficiary_partner_data(partner_name, village_id, beneficiaries, beneficiary_type) values
('CARE', 1, 200, 'HH'),
('CARE', 2, 50, 'individual'),
('Equity', 3, 100, 'HH'),
('AMREF', 4, 100, 'HH'),
('NASA', 5, 100, 'HH');

create table district_summary 
select
    jh.district_name,
    jh.region_name,
    sum(
        case
            when bpd.beneficiary_type = 'HH' then bpd.beneficiaries * 6
            else bpd.beneficiaries
        end
    ) as individual_beneficiaries,
    round(
        sum(
            case 
                when bpd.beneficiary_type = 'HH' then bpd.beneficiaries * 6
                else bpd.beneficiaries
            end
        ) / jh.district_population, 4
    ) as beneficiaries_ratio
from jurisdiction_hierarchy jh
join village_location vl on jh.district_id = vl.district_id
join beneficiary_partner_data bpd on vl.village_id = bpd.village_id
group by jh.district_name, jh.region_name, jh.district_population;

select * from district_summary;

create table partner_summary 
select
bpd.partner_name,
COUNT(distinct vl.village_id) as villages_supported,
COUNT(distinct jh.district_id) as districts_supported
from beneficiary_partner_data bpd
join village_location vl on bpd.village_id = vl.village_id
join jurisdiction_hierarchy jh on vl.district_id = jh.district_id
group by bpd.partner_name;

select * from partner_summary;


