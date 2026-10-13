#!/bin/bash
set -e

echo "=========================================="
echo "  Запуск MySQL контейнера"
echo "=========================================="
echo "Время: $(date)"
echo "Хост: $HOSTNAME"
echo "=========================================="

# Функция ожидания готовности MySQL
wait_for_mysql() {
    echo "[entrypoint] Ожидание запуска MySQL..."
    until mysqladmin ping -h localhost --silent 2>/dev/null; do
        sleep 2
    done
    echo "[entrypoint] MySQL успешно запущен"
}

# Если передана команда mysqld
if [ "$1" = "mysqld" ]; then
    # Запускаем MySQL в фоне для выполнения дополнительных действий
    mysqld --user=mysql &
    MYSQL_PID=$!
    
    # Ждем готовности
    wait_for_mysql
    
    # Выполняем дополнительные настройки (если нужны)
    echo "[entrypoint] Применение дополнительных настроек..."
    
    # Возвращаем управление основному процессу
    wait $MYSQL_PID
else
    # Выполняем переданную команду
    exec "$@"
fi