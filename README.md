# WoW-Legion-Server

Серверная платформа World of Warcraft Legion 7.3.5 (Build 26972) на базе открытого ядра
[LegionCore 7.3.5](https://github.com/The-Legion-Preservation-Project/LegionCore-7.3.5).

## Поддерживаемые платформы

* macOS (Homebrew)
* Linux (Ubuntu/Debian)

## Требования

* C++ компилятор с поддержкой C++ (Clang / AppleClang / GCC)
* CMake 3.x
* Boost
* OpenSSL
* MariaDB / MySQL (клиентские библиотеки для сборки, сервер — для запуска)
* Git

## Быстрый старт

### 1. Установка зависимостей

macOS:

```bash
./scripts/setup-deps-macos.sh
```

Linux (Ubuntu/Debian):

```bash
./scripts/setup-deps-linux.sh
```

### 2. Сборка ядра

```bash
./scripts/build.sh
```

Скрипт автоматически:

1. клонирует исходники LegionCore (если каталог `LegionCore-7.3.5` отсутствует);
2. конфигурирует проект через CMake (на macOS автоматически подставляет пути
   Homebrew для OpenSSL и MySQL client);
3. собирает `worldserver`, `bnetserver` и инструменты извлечения данных
   (`mapextractor`, `vmap4extractor`, `vmap4assembler`, `mmaps_generator`);
4. устанавливает бинарники в `~/legionserver` (переопределяется через `INSTALL_DIR`).

Переменные окружения: `CORE_DIR`, `CORE_REPO`, `INSTALL_DIR`, `BUILD_TYPE`, `JOBS`, `TOOLS`.

Пример:

```bash
INSTALL_DIR=/opt/legion JOBS=8 ./scripts/build.sh
```

### 3. Базы данных

```bash
MYSQL_ROOT_PASSWORD=... ./scripts/setup-db.sh
```

Создаёт базы: `auth`, `characters`, `world`, `hotfixes`, `logs` и пользователя БД.

Затем импортируйте базовые дампы:

```bash
mysql -ulegion -p auth       < LegionCore-7.3.5/sql/base/auth_database.sql
mysql -ulegion -p characters < LegionCore-7.3.5/sql/base/characters_database.sql
```

Дампы `world` и `hotfixes` не входят в репозиторий ядра — их нужно скачать из
релизов/коммьюнити LegionCore и импортировать аналогично. Инкрементальные
обновления находятся в `LegionCore-7.3.5/sql/updates`.

### 4. Извлечение данных клиента

Требуется клиент WoW Legion 7.3.5 build 26972. Запустите из каталога клиента:

1. `mapextractor`
2. `vmap4extractor`
3. `vmap4assembler`
4. `mmaps_generator`

Полученные каталоги `dbc`, `maps`, `vmaps`, `mmaps`, `cameras`, `gt` укажите в
`worldserver.conf` (`DataDir`).

### 5. Запуск

1. Скопируйте `worldserver.conf.dist` → `worldserver.conf` и
   `bnetserver.conf.dist` → `bnetserver.conf` в `~/legionserver/etc`, настройте
   подключения к БД (`LoginDatabaseInfo`, `WorldDatabaseInfo`,
   `CharacterDatabaseInfo`, `HotfixDatabaseInfo`).
2. Запустите `bnetserver` (авторизация), затем `worldserver` (игровой мир).

## Структура репозитория

```
scripts/                  скрипты установки зависимостей, сборки и настройки БД
modules/                  пользовательские модули (см. modules/ExampleModule)
docs/                     документация
.github/workflows/        CI: автоматическая сборка ядра
```

## Модули

Весь дополнительный функционал реализуется через модули, не изменяющие ядро.
Каждый модуль имеет структуру:

```
ModuleName/
  Source/      C++ исходники
  Scripts/     скрипты (ScriptLoader и т.п.)
  Config/      конфигурационные файлы
  SQL/         SQL для БД
  README.md    описание модуля
```

Шаблон: [modules/ExampleModule](modules/ExampleModule).
