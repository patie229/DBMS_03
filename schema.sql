-- =========================================================================
--  schema.sql  --  Bochum City Library : schéma relationnel
--  Module : DBMS_03  --  THGA Bochum
-- =========================================================================
--
--  Six relations : author, book, writes (relation N:M), copy, member, loan.
--  Toutes les contraintes ON DELETE / ON UPDATE sont déclarées explicitement.
--  Choix par défaut : RESTRICT (le plus prudent) ; CASCADE seulement quand
--  le scénario réel l'exige (mise à jour d'une clé identifiante).
-- =========================================================================

PRAGMA foreign_keys = ON;   -- doit être ré-activé à chaque connexion SQLite

-- -------------------------------------------------------------------------
--  Auteurs : clé de substitution car les noms ne sont jamais uniques.
-- -------------------------------------------------------------------------
CREATE TABLE author (
    author_id  INTEGER PRIMARY KEY,
    last_name  TEXT    NOT NULL,
    first_name TEXT    NOT NULL
);

-- -------------------------------------------------------------------------
--  Livres : ISBN comme clé naturelle (mondialement unique et stable).
-- -------------------------------------------------------------------------
CREATE TABLE book (
    isbn      TEXT    PRIMARY KEY,
    title     TEXT    NOT NULL,
    pub_year  INTEGER NOT NULL
);

-- -------------------------------------------------------------------------
--  writes : décomposition de la relation N:M Author <-> Book.
--  Clé primaire composite (author_id, isbn) : aucune ligne ne peut être
--  dupliquée. Les deux clés étrangères sont en RESTRICT pour interdire la
--  suppression d'un auteur tant qu'il a écrit au moins un livre référencé.
-- -------------------------------------------------------------------------
CREATE TABLE writes (
    author_id INTEGER NOT NULL,
    isbn      TEXT    NOT NULL,
    PRIMARY KEY (author_id, isbn),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (isbn)      REFERENCES book(isbn)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- -------------------------------------------------------------------------
--  Exemplaires physiques : un livre peut avoir plusieurs copies en rayon.
-- -------------------------------------------------------------------------
CREATE TABLE copy (
    copy_no    INTEGER PRIMARY KEY,
    isbn       TEXT    NOT NULL,
    shelf_loc  TEXT    NOT NULL,
    FOREIGN KEY (isbn) REFERENCES book(isbn)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- -------------------------------------------------------------------------
--  Adhérents : email déclaré UNIQUE  =>  c'est une clé candidate alternative
--  (Lecture 03 : « alternate key »). La PK reste member_no.
-- -------------------------------------------------------------------------
CREATE TABLE member (
    member_no   INTEGER PRIMARY KEY,
    full_name   TEXT    NOT NULL,
    email       TEXT    NOT NULL UNIQUE,
    enrolled_on DATE    NOT NULL
);

-- -------------------------------------------------------------------------
--  Prêts : événement, donc clé de substitution loan_id.
--  return_date NULLABLE : un prêt en cours n'a pas (encore) de date de retour.
-- -------------------------------------------------------------------------
CREATE TABLE loan (
    loan_id     INTEGER PRIMARY KEY,
    member_no   INTEGER NOT NULL,
    copy_no     INTEGER NOT NULL,
    loan_date   DATE    NOT NULL,
    return_date DATE,                    -- NULL = prêt encore en cours
    FOREIGN KEY (member_no) REFERENCES member(member_no)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (copy_no)   REFERENCES copy(copy_no)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
