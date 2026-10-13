FROM mysql:8.4

LABEL maintainer="ogoreltsev07@bk.ru"
LABEL description="Custom MySQL container for course work"
LABEL version="1.0"

COPY config/my.cnf /etc/mysql/conf.d/custom.cnf

EXPOSE 3306

CMD ["mysqld"]