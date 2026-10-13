FROM mysql:8.4

LABEL maintainer="student@example.com"
LABEL description="Custom MySQL container for course work"
LABEL version="1.0"

# Копируем кастомную конфигурацию
COPY config/my.cnf /etc/mysql/conf.d/custom.cnf

# Копируем скрипты инициализации
COPY init/ /docker-entrypoint-initdb.d/

EXPOSE 3306

CMD ["mysqld"]