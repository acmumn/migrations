CREATE TABLE members_members
    ( id    INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , name  VARCHAR(64) NOT NULL
    , x500  VARCHAR(16) NOT NULL UNIQUE
    , card  CHAR(17) NOT NULL UNIQUE
    , admin BOOLEAN NOT NULL DEFAULT false
    );
CREATE TABLE members_payments
    ( id        INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , member_id INTEGER UNSIGNED NOT NULL UNIQUE
    , date_from DATETIME NOT NULL
    , date_to   DATETIME NOT NULL
    , FOREIGN KEY (member_id) REFERENCES members_members(id)
    );
CREATE TABLE members_jwt_escrow
    ( id        INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , member_id INTEGER UNSIGNED NOT NULL
    , secret    BINARY(16) NOT NULL UNIQUE -- secret is a UUID
    , created   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    , FOREIGN KEY (member_id) REFERENCES members_members(id)
    );
