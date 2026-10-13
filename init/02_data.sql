-- Заполнение тестовыми данными

USE university_db;

-- Добавление студентов
INSERT INTO students (first_name, last_name, email, enrollment_date, gpa) VALUES
('Иван', 'Петров', 'ivan.petrov@university.ru', '2024-09-01', 4.50),
('Мария', 'Сидорова', 'maria.sidorova@university.ru', '2024-09-01', 4.75),
('Алексей', 'Смирнов', 'aleksey.smirnov@university.ru', '2023-09-01', 4.20);

-- Добавление курсов
INSERT INTO courses (course_code, course_name, credits, description) VALUES
('CS101', 'Введение в программирование', 5, 'Основы алгоритмов и структур данных'),
('DB201', 'Базы данных', 4, 'Проектирование и администрирование БД'),
('NET301', 'Компьютерные сети', 3, 'Основы сетевых технологий');

-- Добавление оценок
INSERT INTO grades (student_id, course_id, grade, semester) VALUES
(1, 1, 4.50, '2024-1'),
(1, 2, 4.75, '2024-1'),
(2, 1, 5.00, '2024-1'),
(2, 2, 4.50, '2024-1'),
(3, 1, 4.00, '2024-1');