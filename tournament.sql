-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

-- You must create the database manually in the psgl console
-- CREATE DATABASE tournament
-- then use \i command to import this file
-- \i tournament.sql

CREATE TABLE players (
    id		serial	PRIMARY KEY,
    name	varchar(40) NOT NULL
);

CREATE TABLE matches (
    id		serial	PRIMARY KEY,
    winner	integer NOT NULL REFERENCES players (id),
    loser	integer NOT NULL REFERENCES players (id)
);

-- using self join to get winner view
CREATE VIEW winners AS
SELECT players.id, players.name, count(matches.winner) AS won
   	FROM players LEFT JOIN matches
        ON players.id = matches.winner
   	GROUP BY players.id
   	ORDER BY won DESC;

-- using self join to get losers view
CREATE VIEW losers AS
SELECT players.id, players.name, count(matches.loser) AS lost
   	FROM players LEFT JOIN matches
        ON players.id = matches.loser
   	GROUP BY players.id
   	ORDER BY lost DESC;

-- using winners and losers views to create standings view
CREATE VIEW standings AS
SELECT winners.id, winners.name, winners.won, winners.won + losers.lost as played 
	FROM winners, losers
	WHERE winners.id = losers.id
	ORDER BY won DESC;

-- create row numbered views for pairings view
CREATE VIEW odd AS
SELECT row_number() OVER (ORDER BY won) as num, id, name 
	FROM standings;

CREATE VIEW even AS
SELECT 1+row_number() OVER (ORDER BY won) as num, id, name 
	FROM standings;

CREATE VIEW pairings AS
SELECT odd.id, odd.name, even.id AS id2, even.name AS name2 
	FROM odd, even
	WHERE odd.num = even.num AND odd.num%2 = 0;