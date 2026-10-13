FROM mysql:8.4

# Метаданные
LABEL maintainer="ogoreltsev07@bk.ru"
LABEL description="Custom MySQL container for course work"

# Копируем конфиг
COPY config/my.cnf /etc/mysql/conf.d/custom.cnf

# Копируем скрипты инициализации
COPY init/ /docker-entrypoint-initdb.d/

EXPOSE 3306