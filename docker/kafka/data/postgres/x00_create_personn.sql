CREATE TABLE public.personn
(
    personn_id SERIAL ,
    full_name varchar(50),
    nu_personn varchar(10),
    country_code varchar(3),
    flag_active boolean NOT NULL DEFAULT true,
    created_at timestamp  DEFAULT CURRENT_TIMESTAMP,
    UPDATE_TS TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT personn_pkey PRIMARY KEY (personn_id)
);


CREATE TRIGGER personn_updated_at_modtime BEFORE UPDATE ON public.personn FOR EACH ROW EXECUTE PROCEDURE public.update_updated_at_column();

GRANT SELECT ON public.personn TO connect_user;
