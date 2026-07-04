#!/usr/bin/env bash
# Create the MariaDB/MySQL databases and user for LegionCore 7.3.5.
#
# Usage:
#   MYSQL_ROOT_PASSWORD=... ./scripts/setup-db.sh
#
# Options (via environment variables):
#   DB_USER  - database user to create (default: legion)
#   DB_PASS  - password for the database user (default: legion)
#   MYSQL    - mysql client command (default: mysql -uroot)
set -euo pipefail

DB_USER="${DB_USER:-legion}"
DB_PASS="${DB_PASS:-legion}"
MYSQL="${MYSQL:-mysql -uroot}"
if [[ -n "${MYSQL_ROOT_PASSWORD:-}" ]]; then
    MYSQL="mysql -uroot -p$MYSQL_ROOT_PASSWORD"
fi

$MYSQL <<SQL
CREATE DATABASE IF NOT EXISTS auth       DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE DATABASE IF NOT EXISTS characters DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE DATABASE IF NOT EXISTS world      DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE DATABASE IF NOT EXISTS hotfixes   DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE DATABASE IF NOT EXISTS logs       DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON auth.*       TO '$DB_USER'@'localhost';
GRANT ALL PRIVILEGES ON characters.* TO '$DB_USER'@'localhost';
GRANT ALL PRIVILEGES ON world.*      TO '$DB_USER'@'localhost';
GRANT ALL PRIVILEGES ON hotfixes.*   TO '$DB_USER'@'localhost';
GRANT ALL PRIVILEGES ON logs.*       TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
SQL

echo "Databases created: auth, characters, world, hotfixes, logs"
echo "User: $DB_USER"
echo "Next: import the base SQL dumps from the LegionCore 'sql' directory."
