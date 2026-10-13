#!/bin/bash
# Скрипт для восстановления MySQL базы данных из бэкапа

set -e

# Проверяем аргументы
if [ -z "$1" ]; then
    echo "Ошибка: не указан файл бэкапа"
    echo "Использование: ./restore.sh <путь_к_файлу_бэкапа.sql.gz>"
    echo ""
    echo "Доступные бэкапы:"
    ls -lh /backups/backup_*.sql.gz 2>/dev/null || echo "  Бэкапы не найдены"
    exit 1
fi

BACKUP_FILE="$1"

# Проверяем существование файла
if [ ! -f "${BACKUP_FILE}" ]; then
    echo "Ошибка: файл ${BACKUP_FILE} не найден"
    exit 1
fi

echo "=========================================="
echo "  Начало восстановления из бэкапа"
echo "  Файл: ${BACKUP_FILE}"
echo "  Время: $(date)"
echo "=========================================="

# Создаем резервную копию текущих данных
echo "[restore] Создание резервной копии текущих данных..."
docker exec course_mysql mysqldump \
    -u root \
    -p${MYSQL_ROOT_PASSWORD} \
    --all-databases \
    | gzip > "/backups/pre_restore_$(date +%Y%m%d_%H%M%S).sql.gz"

# Восстанавливаем из бэкапа
echo "[restore] Восстановление данных..."
gunzip -c "${BACKUP_FILE}" | docker exec -i course_mysql \
    mysql -u root -p${MYSQL_ROOT_PASSWORD}

echo "=========================================="
echo "  Восстановление успешно завершено"
echo "=========================================="
echo "Рекомендуется перезапустить контейнер:"
echo "  docker-compose restart mysql"