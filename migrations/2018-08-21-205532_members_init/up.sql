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
