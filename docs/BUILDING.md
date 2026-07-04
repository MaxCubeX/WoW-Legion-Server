# Сборка LegionCore 7.3.5

## Автоматическая сборка

Рекомендуемый способ — скрипт `scripts/build.sh` (Linux и macOS). См. README.

## Ручная сборка

```bash
git clone --depth 1 https://github.com/The-Legion-Preservation-Project/LegionCore-7.3.5.git
cd LegionCore-7.3.5
mkdir build && cd build
cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$HOME/legionserver \
  -DTOOLS=1 \
  -DWITH_WARNINGS=0
make -j$(nproc)   # macOS: make -j$(sysctl -n hw.ncpu)
make install
```

### Особенности macOS

Homebrew устанавливает OpenSSL и MySQL client вне стандартных путей поиска CMake:

```bash
cmake .. \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$HOME/legionserver \
  -DTOOLS=1 -DWITH_WARNINGS=0 \
  -DOPENSSL_ROOT_DIR=$(brew --prefix openssl@3) \
  -DMYSQL_ADD_INCLUDE_PATH=$(brew --prefix mysql-client)/include \
  -DMYSQL_LIBRARY=$(brew --prefix mysql-client)/lib/libmysqlclient.dylib
```

`scripts/build.sh` делает это автоматически.

## Результат сборки

В `$INSTALL_DIR/bin`:

* `worldserver` — игровой сервер
* `bnetserver` — сервер авторизации (Battle.net)
* `mapextractor`, `vmap4extractor`, `vmap4assembler`, `mmaps_generator` — инструменты извлечения данных клиента

В `$INSTALL_DIR/etc` — примеры конфигураций `*.conf.dist`.

## Типичные проблемы

* **Не найден Boost** — установите `libboost-all-dev` (Linux) или `brew install boost` (macOS).
* **Не найден OpenSSL на macOS** — укажите `OPENSSL_ROOT_DIR` (см. выше).
* **Не найден MySQL client** — установите `libmysqlclient-dev` (Linux) или `brew install mysql-client` (macOS).
* **Мало памяти при сборке** — уменьшите число потоков: `JOBS=1 ./scripts/build.sh`.
