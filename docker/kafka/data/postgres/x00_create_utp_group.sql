CREATE TABLE public.utp_group
(
    utp_group_id SERIAL ,
    group_name varchar(50) NOT NULL,
    flag_active boolean NOT NULL DEFAULT true,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP,
    UPDATE_TS TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    
    CONSTRAINT utp_group_pkey PRIMARY KEY (utp_group_id),
    CONSTRAINT utp_group_group_name_key UNIQUE (group_name)
);

CREATE TRIGGER utp_group_updated_at_modtime BEFORE UPDATE ON utp_group FOR EACH ROW EXECUTE PROCEDURE public.update_updated_at_column();

GRANT SELECT ON utp_group TO connect_user;
