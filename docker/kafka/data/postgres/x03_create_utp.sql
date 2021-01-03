CREATE TABLE utp
(
    utp_id SERIAL ,
    utp_name varchar(100) NOT NULL,
    utp_description varchar(500),
    utp_type varchar(10) DEFAULT 'EVENT',
    utp_input_type varchar(10) DEFAULT 'AUTO',
    utp_impact  varchar(20) NOT NULL DEFAULT 'DEFAULT',
    flag_active boolean DEFAULT true,
    probation_duration_in_month integer DEFAULT 3,
    utp_group_id integer,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    UPDATE_TS TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    
    CONSTRAINT utp_pkey PRIMARY KEY (utp_id),
    CONSTRAINT utp_utp_name_key UNIQUE (utp_name),
    CONSTRAINT utp_utp_group_id_fkey FOREIGN KEY (utp_group_id)
        REFERENCES public.utp_group (utp_group_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

COMMENT ON COLUMN public.utp.utp_type
    IS 'Can be EVENT/STATE/TRIGGER';

COMMENT ON COLUMN public.utp.utp_input_type
    IS 'Can be AUTO/MANUAL';

COMMENT ON COLUMN public.utp.utp_impact
    IS 'Can be WARNING / DEFAULT';

COMMENT ON COLUMN public.utp.flag_active
    IS 'Activate/Deactivate the UTP';

CREATE TRIGGER utp_updated_at_modtime BEFORE UPDATE ON utp FOR EACH ROW EXECUTE PROCEDURE public.update_updated_at_column();

GRANT SELECT ON utp TO connect_user;
