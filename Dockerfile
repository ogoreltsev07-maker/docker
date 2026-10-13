FROM mysql:8.4

LABEL maintainer="ogoreltsev07@bk.ru"
LABEL description="Custom MySQL container for course work"
LABEL version="1.0"

# Копируем кастомную конфигурацию
COPY config/my.cnf /etc/mysql/conf.d/custom.cnf

# Копируем скрипты инициализации
COPY init/ /docker-entrypoint-initdb.d/

# Копируем entrypoint скрипт
COPY scripts/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Устанавливаем кастомный entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

EXPOSE 3306

CMD ["mysqld"]