CREATE TABLE IF NOT EXISTS ndod.personn (
  personn_id SERIAL PRIMARY KEY,
  full_name varchar,
  nu_personn varchar,
  country_code int,
  flag_active boolean NOT NULL DEFAULT true,
  created_at timestamp DEFAULT (now()),
  updated_at timestamp DEFAULT (now())
);

CREATE TABLE IF NOT EXISTS ndod.racine (
  racine_id SERIAL PRIMARY KEY,
  flag_active boolean NOT NULL DEFAULT true,
  created_at timestamp DEFAULT (now()),
  updated_at timestamp DEFAULT (now())
);

CREATE TABLE IF NOT EXISTS ndod.lnk_personn_racine (
  personn_id int,
  racine_id int,
  flag_active boolean NOT NULL DEFAULT true,
  created_at timestamp DEFAULT (now()),
  updated_at timestamp DEFAULT (now()),
  PRIMARY KEY (personn_id, racine_id)
);

CREATE TABLE IF NOT EXISTS ndod.account (
  account_id SERIAL PRIMARY KEY,
  nu_account varchar,
  racine_id int
);

CREATE TABLE IF NOT EXISTS ndod.utp_group (
  utp_group_id SERIAL PRIMARY KEY,
  group_name varchar UNIQUE NOT NULL,
  flag_active boolean NOT NULL DEFAULT true,
  created_at timestamp DEFAULT (now()),
  updated_at timestamp DEFAULT (now())
);

CREATE TABLE IF NOT EXISTS ndod.utp (
  utp_id SERIAL PRIMARY KEY,
  utp_name varchar UNIQUE NOT NULL,
  utp_description varchar,
  utp_type varchar DEFAULT 'AUTO',
  utp_input_type varchar DEFAULT 'AUTO',
  utp_impact varchar NOT NULL,
  flag_active boolean DEFAULT true,
  probation_duration_in_month int DEFAULT 3,
  utp_group_id int,
  created_at timestamp DEFAULT (now()),
  updated_at timestamp DEFAULT (now())
);

CREATE TABLE IF NOT EXISTS ndod.CRM_events (
  utp_id int,
  personn_id int,
  racine_id int,
  account_id int,
  event_date timestamp,
  event_type varchar NOT NULL,
  flag_active boolean DEFAULT true,
  created_at timestamp DEFAULT (now()),
  updated_at timestamp DEFAULT (now()),
  PRIMARY KEY (utp_id, personn_id, racine_id, account_id, event_date, event_type)
);

ALTER TABLE ndod.lnk_personn_racine ADD FOREIGN KEY (personn_id) REFERENCES ndod.personn (personn_id);

ALTER TABLE ndod.lnk_personn_racine ADD FOREIGN KEY (racine_id) REFERENCES ndod.racine (racine_id);

ALTER TABLE ndod.account ADD FOREIGN KEY (racine_id) REFERENCES ndod.racine (racine_id);

ALTER TABLE ndod.utp ADD FOREIGN KEY (utp_group_id) REFERENCES ndod.utp_group (utp_group_id);

ALTER TABLE ndod.CRM_events ADD FOREIGN KEY (utp_id) REFERENCES ndod.utp (utp_id);

ALTER TABLE ndod.CRM_events ADD FOREIGN KEY (personn_id) REFERENCES ndod.personn (personn_id);

ALTER TABLE ndod.CRM_events ADD FOREIGN KEY (racine_id) REFERENCES ndod.racine (racine_id);

ALTER TABLE ndod.CRM_events ADD FOREIGN KEY (account_id) REFERENCES ndod.account (account_id);


COMMENT ON COLUMN ndod.personn.flag_active IS 'Activate/Deactivate the group and all UTP that belong to this group';

COMMENT ON COLUMN ndod.racine.flag_active IS 'Activate/Deactivate the group and all UTP that belong to this group';

COMMENT ON COLUMN ndod.lnk_personn_racine.flag_active IS 'Activate/Deactivate the group and all UTP that belong to this group';

COMMENT ON COLUMN ndod.utp_group.flag_active IS 'Activate/Deactivate the group and all UTP that belong to this group';

COMMENT ON COLUMN ndod.utp.utp_type IS 'Can be EVENT/STATE/TRIGGER';

COMMENT ON COLUMN ndod.utp.utp_input_type IS 'Can be AUTO/MANUAL';

COMMENT ON COLUMN ndod.utp.utp_impact IS 'Can be WARNING / DEFAULT';

COMMENT ON COLUMN ndod.utp.flag_active IS 'Activate/Deactivate the UTP';

COMMENT ON COLUMN ndod.CRM_events.event_date IS 'Business date when the event appear';

COMMENT ON COLUMN ndod.CRM_events.event_type IS 'Can be IN/OUT';
