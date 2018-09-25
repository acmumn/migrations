CREATE TABLE members
    ( id        INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , name      VARCHAR(128) NOT NULL
    , x500      VARCHAR(16) NOT NULL UNIQUE -- A non-UMN student gets an x500 starting with `!`.
    , card      CHAR(17) UNIQUE -- The long number on the card.
    , email     VARCHAR(128) NOT NULL UNIQUE
	, discordID UNSIGNED BIGINT UNIQUE
    );
CREATE TABLE jwt_escrow
    ( id        INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , member_id INTEGER UNSIGNED NOT NULL UNIQUE
    , uuid      BINARY(16) NOT NULL UNIQUE
    , created   DATETIME NOT NULL DEFAULT NOW()
    , FOREIGN KEY (member_id) REFERENCES members(id)
    );
CREATE TABLE member_bans
    ( id             INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , member_id      INTEGER UNSIGNED NOT NULL
    , issued_by      INTEGER UNSIGNED
    , date_from      DATETIME NOT NULL
    , date_to        DATETIME
    , invalidated_at DATETIME
    , invalidated_by INTEGER UNSIGNED
    , notes          TEXT NOT NULL
    , FOREIGN KEY (issued_by) REFERENCES members(id)
    , FOREIGN KEY (invalidated_by) REFERENCES members(id)
    , FOREIGN KEY (member_id) REFERENCES members(id)
    );
CREATE TABLE member_payments
    ( id        INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , member_id INTEGER UNSIGNED NOT NULL UNIQUE
    , date_from DATETIME NOT NULL
    , date_to   DATETIME NOT NULL
    , notes     TEXT NOT NULL
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
    ( id      INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , name    VARCHAR(128) NOT NULL UNIQUE
	, deleted BOOLEAN NOT NULL DEFAULT false
	, hidden  BOOLEAN NOT NULL DEFAULT false
    );
CREATE TABLE mail_templates
    ( id              INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , name            VARCHAR(128) NOT NULL UNIQUE
    , contents        LONGTEXT NOT NULL
    , markdown        BOOLEAN NOT NULL DEFAULT false
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
	, send_after   DATETIME NOT NULL DEFAULT NOW() -- Do not send before this time.
    , send_started BOOLEAN NOT NULL DEFAULT false -- Set once sending has started.
    , send_done    BOOLEAN NOT NULL DEFAULT false -- Set once sending has completed.
    , FOREIGN KEY (template_id) REFERENCES mail_templates(id)
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
CREATE TABLE mail_global_unsubscribes
    ( id    INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , email VARCHAR(128) NOT NULL
    );
CREATE TABLE mail_list_unsubscribes
    ( id              INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , email           VARCHAR(128) NOT NULL
    , mailing_list_id INTEGER UNSIGNED NOT NULL
    , FOREIGN KEY (mailing_list_id) REFERENCES mailing_lists(id)
    );

INSERT INTO mail_templates (name, contents)
VALUES ('login', '<!doctype html>\n<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"></head><body>Click <a href="{{ relative_url(path="/login/" ~ uuid) }}">here</a> to log in.</body></html>');
