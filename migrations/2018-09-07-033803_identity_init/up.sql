CREATE TABLE identity_jwt_escrow
    ( id        INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY
    , member_id INTEGER UNSIGNED NOT NULL UNIQUE
    , uuid      BINARY(16) NOT NULL UNIQUE
    , created   DATETIME NOT NULL DEFAULT NOW()
    , FOREIGN KEY (member_id) REFERENCES members_members(id)
    );
