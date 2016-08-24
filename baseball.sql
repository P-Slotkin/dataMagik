CREATE TABLE players (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  team_id INTEGER,

  FOREIGN KEY(team_id) REFERENCES player(id)
);

CREATE TABLE teams (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES team(id)
);

CREATE TABLE owners (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

INSERT INTO
  owners (id, name)
VALUES
  (1, "Steinbrenner"), (2, "Harrington");

INSERT INTO
  players (id, name, team_id)
VALUES
  (1, "Jeter", 1),
  (2, "Tino", 1),
  (3, "Bernie", 1),
  (4, "Posada", 1),
  (5, "Garciaparra", 2),
  (6, "Pedro", 2),
  (7, "Manny", 2),
  (8, "Varitek", 2);

INSERT INTO
  teams (id, name, owner_id)
VALUES
  (1, "Yankees", 1),
  (2, "Red Sox", 2);
