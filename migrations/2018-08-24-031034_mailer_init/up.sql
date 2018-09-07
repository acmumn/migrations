CREATE TABLE mailer_lists
    ( id   INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , name VARCHAR(128) NOT NULL UNIQUE
    );
CREATE TABLE mailer_templates
    ( id              INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , mailing_list_id INTEGER UNSIGNED NOT NULL
    , name            VARCHAR(128) NOT NULL
    , contents        LONGTEXT NOT NULL
    , markdown        BOOLEAN NOT NULL DEFAULT false
    , FOREIGN KEY (mailing_list_id) REFERENCES mailer_lists(id)
    );
CREATE TABLE mailer_queue
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
    , FOREIGN KEY (template_id) REFERENCES mailer_templates(id)
    );
CREATE TABLE mailer_member_subscriptions
    ( id              INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , member_id       INTEGER UNSIGNED NOT NULL
    , mailing_list_id INTEGER UNSIGNED NOT NULL
    , FOREIGN KEY (mailing_list_id) REFERENCES mailer_lists(id)
    , FOREIGN KEY (member_id) REFERENCES members_members(id)
    );
CREATE TABLE mailer_other_subscriptions
    ( id              INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , email           VARCHAR(128) NOT NULL
    , mailing_list_id INTEGER UNSIGNED NOT NULL
    , FOREIGN KEY (mailing_list_id) REFERENCES mailer_lists(id)
    );
CREATE TABLE mailer_unsubscribes
    ( id              INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , email           VARCHAR(128) NOT NULL
    , mailing_list_id INTEGER UNSIGNED NOT NULL
    , FOREIGN KEY (mailing_list_id) REFERENCES mailer_lists(id)
    );

INSERT INTO mailer_lists (id, name)
VALUES (1, 'identity');
INSERT INTO mailer_templates (mailing_list_id, name, contents)
VALUES (1, 'login', '<!doctype html>\n<html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"></head><body>Click <a href="https://memberlist.internal.acm.umn.edu/login/{{ uuid }}">here</a> to log in.</body></html>');
