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
read -r -a MYSQL_CMD <<< "${MYSQL:-mysql -uroot}"
if [[ -n "${MYSQL_ROOT_PASSWORD:-}" ]]; then
    # MYSQL_PWD keeps the password out of the process list
    export MYSQL_PWD="$MYSQL_ROOT_PASSWORD"
    MYSQL_CMD=(mysql -uroot)
fi

if [[ "$DB_PASS" == "legion" ]]; then
    echo "WARNING: using the default password 'legion' for user '$DB_USER'." >&2
    echo "         Set DB_PASS to a strong password for production use." >&2
fi

# escape single quotes for safe interpolation into SQL string literals
SQL_USER="${DB_USER//\'/\'\'}"
SQL_PASS="${DB_PASS//\'/\'\'}"

"${MYSQL_CMD[@]}" <<SQL
CREATE DATABASE IF NOT EXISTS auth       DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE DATABASE IF NOT EXISTS characters DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE DATABASE IF NOT EXISTS world      DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE DATABASE IF NOT EXISTS hotfixes   DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE DATABASE IF NOT EXISTS logs       DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

CREATE USER IF NOT EXISTS '$SQL_USER'@'localhost' IDENTIFIED BY '$SQL_PASS';
GRANT ALL PRIVILEGES ON auth.*       TO '$SQL_USER'@'localhost';
GRANT ALL PRIVILEGES ON characters.* TO '$SQL_USER'@'localhost';
GRANT ALL PRIVILEGES ON world.*      TO '$SQL_USER'@'localhost';
GRANT ALL PRIVILEGES ON hotfixes.*   TO '$SQL_USER'@'localhost';
GRANT ALL PRIVILEGES ON logs.*       TO '$SQL_USER'@'localhost';
FLUSH PRIVILEGES;
SQL

echo "Databases created: auth, characters, world, hotfixes, logs"
echo "User: $DB_USER"
echo "Next: import the base SQL dumps from the LegionCore 'sql' directory."
