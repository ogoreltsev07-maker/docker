-- Настройка прав доступа

-- Создаем пользователя для приложения (если не создан через ENV)
CREATE USER IF NOT EXISTS 'app_user'@'%' IDENTIFIED BY 'app_password';

-- Предоставляем права только на нашу базу данных
GRANT SELECT, INSERT, UPDATE, DELETE ON university_db.* TO 'app_user'@'%';

-- Права для student пользователя (только чтение)
CREATE USER IF NOT EXISTS 'readonly_user'@'%' IDENTIFIED BY 'readonly_password';
GRANT SELECT ON university_db.* TO 'readonly_user'@'%';

FLUSH PRIVILEGES;