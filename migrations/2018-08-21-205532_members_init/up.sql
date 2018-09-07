CREATE TABLE members_members
    ( id        INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , name      VARCHAR(128) NOT NULL
    , studentId CHAR(7) NOT NULL UNIQUE -- A member who does not have a student ID gets "00xxxxx".
    , x500      VARCHAR(16) UNIQUE
    , card      CHAR(17) UNIQUE -- The long number on the card.
    , email     VARCHAR(128) NOT NULL UNIQUE
    );
CREATE TABLE members_bans
    ( id        INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , member_id INTEGER UNSIGNED NOT NULL UNIQUE
    , date_from DATETIME NOT NULL
    , date_to   DATETIME
    , notes     TEXT
    , FOREIGN KEY (member_id) REFERENCES members_members(id)
    );
CREATE TABLE members_payments
    ( id        INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , member_id INTEGER UNSIGNED NOT NULL UNIQUE
    , date_from DATETIME NOT NULL
    , date_to   DATETIME NOT NULL
    , notes     TEXT
    , FOREIGN KEY (member_id) REFERENCES members_members(id)
    );
CREATE TABLE members_caps
    ( id   INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , name VARCHAR(128) NOT NULL UNIQUE
    );
CREATE TABLE members_tags
    ( id   INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , name VARCHAR(128) NOT NULL UNIQUE
    );
CREATE TABLE members_tag_join
    ( id        INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , member_id INTEGER UNSIGNED NOT NULL UNIQUE
    , tags_id   INTEGER UNSIGNED NOT NULL UNIQUE
    , FOREIGN KEY (member_id) REFERENCES members_members(id)
    , FOREIGN KEY (tags_id) REFERENCES members_tags(id)
    );
CREATE TABLE members_jwt_escrow
    ( id        INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , member_id INTEGER UNSIGNED NOT NULL UNIQUE
    , uuid      BINARY(16) NOT NULL UNIQUE
    , created   DATETIME NOT NULL DEFAULT NOW()
    , FOREIGN KEY (member_id) REFERENCES members_members(id)
    );

INSERT INTO members_caps (name)
VALUES ('mail.list.manage'),
       ('mail.templates.manage'),
       ('mail.send'),
       ('members.add'),
       ('members.acmw.add'),
       ('members.modify'),
       ('members.acmw.modify');
INSERT INTO members_tags (name)
VALUES ('acmw'),
       ('acmw-officer'),
       ('admin'),
       ('identity-op'),
       ('mailer-op'),
       ('members-op');
