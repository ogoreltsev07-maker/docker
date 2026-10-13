#!/bin/bash
# Скрипт для создания бэкапа MySQL базы данных

set -e

# Переменные
BACKUP_DIR="/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
FILENAME="backup_${TIMESTAMP}.sql.gz"
RETENTION_DAYS=7

echo "=========================================="
echo "  Начало создания бэкапа"
echo "  Время: $(date)"
echo "=========================================="

# Создаем директорию для бэкапов
mkdir -p ${BACKUP_DIR}

# Создаем бэкап
echo "[backup] Создание дампа базы данных..."
docker exec course_mysql mysqldump \
    -u root \
    -p${MYSQL_ROOT_PASSWORD} \
    --all-databases \
    --single-transaction \
    --routines \
    --triggers \
    --events \
    | gzip > "${BACKUP_DIR}/${FILENAME}"

# Проверяем размер файла
BACKUP_SIZE=$(du -h "${BACKUP_DIR}/${FILENAME}" | cut -f1)
echo "[backup] Бэкап создан: ${FILENAME} (${BACKUP_SIZE})"

# Удаляем старые бэкапы
echo "[backup] Удаление бэкапов старше ${RETENTION_DAYS} дней..."
find ${BACKUP_DIR} -name "backup_*.sql.gz" -type f -mtime +${RETENTION_DAYS} -delete

echo "=========================================="
echo "  Бэкап успешно завершен"
echo "=========================================="