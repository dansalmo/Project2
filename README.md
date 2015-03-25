Steps to run:

from terminal type:
cd fullstack/vagrant
vagrant up
vagrant ssh
cd /vargant/tournament

You must create the database manually in the psgl console
from terminal type:
psql

run the following commands in psql:
CREATE DATABASE tournament
\i tournament.sql
\q

from terminal type:
python tournament_test.py
