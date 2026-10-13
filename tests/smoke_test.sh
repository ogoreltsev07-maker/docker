#!/bin/bash
# Smoke-тест для проверки корректности развертывания MySQL контейнера

set -e

echo "=========================================="
echo "  Запуск smoke-тестов"
echo "  Время: $(date)"
echo "=========================================="

# Функция для очистки при ошибке
cleanup() {
    echo "[test] Остановка контейнеров..."
    docker-compose down -v
}
trap cleanup EXIT

# Тест 1: Поднимаем контейнеры
echo "[test 1] Поднятие контейнеров..."
docker-compose up -d --build
sleep 5

# Тест 2: Проверяем HEALTHCHECK
echo "[test 2] Проверка HEALTHCHECK..."
TIMEOUT=60
COUNTER=0
until docker inspect --format='{{.State.Health.Status}}' course_mysql | grep -q "healthy"; do
    sleep 2
    COUNTER=$((COUNTER + 2))
    if [ $COUNTER -ge $TIMEOUT ]; then
        echo "[test] ❌ Ошибка: контейнер не стал healthy за ${TIMEOUT} секунд"
        docker logs course_mysql
        exit 1
    fi
done
echo "[test] ✅ Контейнер healthy"

# Тест 3: Проверяем подключение
echo "[test 3] Проверка подключения к MySQL..."
docker exec course_mysql mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "SELECT 1;" > /dev/null 2>&1
echo "[test] ✅ Подключение успешно"

# Тест 4: Проверяем наличие тестовых данных
echo "[test 4] Проверка тестовых данных..."
STUDENTS_COUNT=$(docker exec course_mysql mysql -u root -p${MYSQL_ROOT_PASSWORD} -N -e "SELECT COUNT(*) FROM university_db.students;")
if [ "$STUDENTS_COUNT" -ne 3 ]; then
    echo "[test] ❌ Ошибка: ожидалось 3 студента, получено $STUDENTS_COUNT"
    exit 1
fi
echo "[test] ✅ Данные корректны (студентов: $STUDENTS_COUNT)"

# Тест 5: Проверяем работу бэкапа
echo "[test 5] Проверка скрипта бэкапа..."
docker-compose exec -T mysql /scripts/backup.sh
if [ ! -f "./backups/backup_*.sql.gz" ]; then
    echo "[test] ❌ Ошибка: бэкап не создан"
    exit 1
fi
echo "[test] ✅ Бэкап создан успешно"

echo "=========================================="
echo "  ✅ Все тесты пройдены успешно!"
echo "=========================================="