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
