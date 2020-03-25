DROP TABLE IF EXISTS jhi_user_authority;
DROP TABLE IF EXISTS jhi_authority;
DROP TABLE IF EXISTS jhi_user;
DROP SEQUENCE IF EXISTS hibernate_sequence;

-- Sequence should start after the first insertions required by JHipster (4 users).
CREATE SEQUENCE hibernate_sequence start 5 increment 1;

CREATE TABLE jhi_user (
    id bigint generated by default as identity,
    login VARCHAR(50) NOT NULL,
    password_hash VARCHAR(60) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(254),
    image_url VARCHAR(256),
    activated BOOLEAN NOT NULL,
    lang_key VARCHAR(10),
    activation_key VARCHAR(20),
    reset_key VARCHAR(20),
    created_by VARCHAR(50) NOT NULL,
    created_date TIMESTAMP,
    reset_date TIMESTAMP,
    last_modified_by VARCHAR(50),
    last_modified_date TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE jhi_authority (
    name VARCHAR(50) NOT NULL,
    PRIMARY KEY (name)
);

CREATE TABLE jhi_user_authority (
    user_id bigint NOT NULL,
    authority_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (user_id, authority_name)
);

ALTER TABLE jhi_user
    ADD CONSTRAINT ux_user_email UNIQUE (email);
ALTER TABLE jhi_user
    ADD CONSTRAINT ux_user_login UNIQUE (login);
ALTER TABLE jhi_user_authority
    ADD CONSTRAINT fk_authority_name FOREIGN KEY (authority_name) REFERENCES jhi_authority;
ALTER TABLE jhi_user_authority
    ADD CONSTRAINT fk_user_id FOREIGN KEY (user_id) REFERENCES jhi_user;

INSERT INTO jhi_user (id, login, password_hash, first_name, last_name, email, image_url, activated, lang_key, created_by, last_modified_by)
    VALUES (1, 'system', '$2a$10$mE.qmcV0mFU5NcKh73TZx.z4ueI/.bDWbj0T1BYyqP481kGGarKLG', 'System', 'System', 'system@localhost', NULL, true, 'en', 'system', 'system');
INSERT INTO jhi_user (id, login, password_hash, first_name, last_name, email, image_url, activated, lang_key, created_by, last_modified_by)
    VALUES (2, 'anonymoususer', '$2a$10$j8S5d7Sr7.8VTOYNviDPOeWX8KcYILUVJBsYV83Y5NtECayypx9lO', 'Anonymous', 'User', 'anonymous@localhost', NULL, true, 'en', 'system', 'system');
INSERT INTO jhi_user (id, login, password_hash, first_name, last_name, email, image_url, activated, lang_key, created_by, last_modified_by)
    VALUES (3, 'admin', '$2a$10$gSAhZrxMllrbgj/kkK9UceBPpChGWJA7SYIb1Mqo.n5aNLq1/oRrC', 'Administrator', 'Administrator', 'admin@localhost', NULL, true, 'en', 'system', 'system');
INSERT INTO jhi_user (id, login, password_hash, first_name, last_name, email, image_url, activated, lang_key, created_by, last_modified_by)
    VALUES (4, 'user', '$2a$10$VEjxo0jq2YG9Rbk2HmX9S.k1uZBGYUHdUcid3g/vfiEl7lwWgOH/K', 'User', 'User', 'user@localhost', NULL, true, 'en', 'system', 'system');

INSERT INTO jhi_authority (name)
    VALUES ('ROLE_ADMIN');
INSERT INTO jhi_authority (name)
    VALUES ('ROLE_USER');

INSERT INTO jhi_user_authority (user_id, authority_name)
    VALUES (1, 'ROLE_ADMIN');
INSERT INTO jhi_user_authority (user_id, authority_name)
    VALUES (1, 'ROLE_USER');
INSERT INTO jhi_user_authority (user_id, authority_name)
    VALUES (3, 'ROLE_ADMIN');
INSERT INTO jhi_user_authority (user_id, authority_name)
    VALUES (3, 'ROLE_USER');
INSERT INTO jhi_user_authority (user_id, authority_name)
    VALUES (4, 'ROLE_USER');
