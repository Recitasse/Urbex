#!/bin/bash

SQL_SCRIPT="database/database.sql"
RESET="database/reset_database.sql"

sudo mysql < "$RESET"
sudo mysql < "$SQL_SCRIPT"
