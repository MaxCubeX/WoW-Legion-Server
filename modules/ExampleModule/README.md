# ExampleModule

Шаблон модуля для WoW-Legion-Server. Скопируйте каталог и переименуйте под свой модуль.

## Структура

```
ExampleModule/
  Source/      C++ исходники модуля
  Scripts/     ScriptLoader и игровые скрипты
  Config/      конфигурация модуля (.conf)
  SQL/         SQL-скрипты для баз данных
  README.md    описание модуля
```

## Подключение

1. Добавьте исходники модуля в сборку ядра (каталог `src/server/scripts/Custom`
   LegionCore или через CMake include).
2. Зарегистрируйте скрипты в ScriptLoader (`Scripts/ExampleModuleLoader.cpp`).
3. Импортируйте SQL из `SQL/` в соответствующую базу данных.
4. Скопируйте конфиг из `Config/` в каталог конфигурации сервера.
