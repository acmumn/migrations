CREATE TABLE members
    ( id        INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , name      VARCHAR(128) NOT NULL
    , studentId CHAR(7) NOT NULL UNIQUE -- A member who does not have a student ID gets "00xxxxx".
    , x500      VARCHAR(16) UNIQUE
    , card      CHAR(17) UNIQUE -- The long number on the card.
    , email     VARCHAR(128) NOT NULL UNIQUE
    );
CREATE TABLE jwt_escrow
    ( id        INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , member_id INTEGER UNSIGNED NOT NULL UNIQUE
    , uuid      BINARY(16) NOT NULL UNIQUE
    , created   DATETIME NOT NULL DEFAULT NOW()
    , FOREIGN KEY (member_id) REFERENCES members(id)
    );
CREATE TABLE member_bans
    ( id        INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , member_id INTEGER UNSIGNED NOT NULL UNIQUE
    , date_from DATETIME NOT NULL
    , date_to   DATETIME
    , notes     TEXT
    , FOREIGN KEY (member_id) REFERENCES members(id)
    );
CREATE TABLE member_payments
    ( id        INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , member_id INTEGER UNSIGNED NOT NULL UNIQUE
    , date_from DATETIME NOT NULL
    , date_to   DATETIME NOT NULL
    , notes     TEXT
    , FOREIGN KEY (member_id) REFERENCES members(id)
    );
CREATE TABLE tags
    ( id   INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , name VARCHAR(128) NOT NULL UNIQUE
    );
CREATE TABLE members_tag_join
    ( id        INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , member_id INTEGER UNSIGNED NOT NULL UNIQUE
    , tags_id   INTEGER UNSIGNED NOT NULL UNIQUE
    , FOREIGN KEY (member_id) REFERENCES members(id)
    , FOREIGN KEY (tags_id) REFERENCES tags(id)
    );
CREATE TABLE mailing_lists
    ( id   INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , name VARCHAR(128) NOT NULL UNIQUE
    );
CREATE TABLE mailing_list_templates
    ( id              INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , mailing_list_id INTEGER UNSIGNED NOT NULL
    , name            VARCHAR(128) NOT NULL
    , contents        LONGTEXT NOT NULL
    , markdown        BOOLEAN NOT NULL DEFAULT false
    , FOREIGN KEY (mailing_list_id) REFERENCES mailing_lists(id)
    );
CREATE TABLE mail_send_queue
    ( id           INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , template_id  INTEGER UNSIGNED NOT NULL
    , data         LONGTEXT NOT NULL -- This is JSON, but MariaDB's JSON type is just an alias for
        -- LONGTEXT (and only very recently supported). Note that even on real MySQL, the JSON type
        -- may not be warranted: the main advantage is that JSON functions are faster on MySQL, but
        -- we don't actually use these.
    , email        VARCHAR(128) NOT NULL
    , subject      VARCHAR(128) NOT NULL
    , send_started BOOLEAN NOT NULL DEFAULT false -- Set once sending has started.
    , send_done    BOOLEAN NOT NULL DEFAULT false -- Set once sending has completed.
    , FOREIGN KEY (template_id) REFERENCES mailing_list_templates(id)
    );
CREATE TABLE mail_member_subscriptions
    ( id              INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , member_id       INTEGER UNSIGNED NOT NULL
    , mailing_list_id INTEGER UNSIGNED NOT NULL
    , FOREIGN KEY (mailing_list_id) REFERENCES mailing_lists(id)
    , FOREIGN KEY (member_id) REFERENCES members(id)
    );
CREATE TABLE mail_other_subscriptions
    ( id              INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , email           VARCHAR(128) NOT NULL
    , mailing_list_id INTEGER UNSIGNED NOT NULL
    , FOREIGN KEY (mailing_list_id) REFERENCES mailing_lists(id)
    );
CREATE TABLE mail_unsubscribes
    ( id              INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , email           VARCHAR(128) NOT NULL
    , mailing_list_id INTEGER UNSIGNED NOT NULL
    , FOREIGN KEY (mailing_list_id) REFERENCES mailing_lists(id)
    );

INSERT INTO tags (name)
VALUES ('acmw'),
       ('acmw-officer'),
       ('admin'),
       ('identity-op'),
       ('mailer-op'),
       ('members-op');

INSERT INTO mailing_lists (id, name)
VALUES (1, 'identity');
INSERT INTO mailing_list_templates (mailing_list_id, name, contents)
VALUES (1, 'login', '<!doctype html>\n<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"></head><body>Click <a href="{{ relative_url(path="/login/" ~ uuid) }}">here</a> to log in.</body></html>');
