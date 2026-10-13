FROM mysql:8.4

LABEL maintainer="ogoreltsev07@bk.ru"
LABEL description="Custom MySQL container for course work"
LABEL version="1.0"

EXPOSE 3306

CMD ["mysqld"]