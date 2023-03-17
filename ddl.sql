-- Создание таблиц

-- Создание схемы базы данных гитарного магазина
CREATE SCHEMA social_network_db;

-- Инфомация о пользователях
CREATE TABLE social_network_db.users(
  user_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  birthday DATE NOT NULL,
  cnt_friends INTEGER NOT NULL,
  cnt_groups INTEGER NOT NULL
);

-- Информация о чатах
CREATE TABLE social_network_db.chats(
  chat_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  cnt_users INTEGER CHECK ( cnt_users >= 0 ),
  privacy INTEGER CHECK ( privacy in (1, 2, 3) ),
  cnt_messages INTEGER CHECK ( cnt_messages >= 0 )
);

-- Информация о группах
CREATE TABLE social_network_db.groups(
  group_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  cnt_users INTEGER CHECK ( cnt_users >= 0 ),
  privacy INTEGER CHECK ( privacy in (1, 2, 3) ),
  type VARCHAR(255),
  info VARCHAR(255)
);

-- Информация о друзьях
CREATE TABLE social_network_db.friends(
  user_id_1 SERIAL NOT NULL ,
  user_id_2 SERIAL NOT NULL ,
  date_of_start DATE NOT NULL ,
  relation VARCHAR(255),
  FOREIGN KEY (user_id_1)
    REFERENCES social_network_db.users(user_id),
  FOREIGN KEY (user_id_2)
    REFERENCES social_network_db.users(user_id)
);

-- Таблица-связка "Пользователи - группы"
CREATE TABLE social_network_db.users_x_groups(
  user_id SERIAL NOT NULL ,
  group_id SERIAL NOT NULL ,
  admin INTEGER NOT NULL,
  banned INTEGER NOT NULL,
  FOREIGN KEY (user_id)
    REFERENCES social_network_db.users(user_id),
  FOREIGN KEY (group_id)
    REFERENCES social_network_db.groups(group_id)
);

--Таблица-связка "Пользователи - чаты"
CREATE TABLE social_network_db.users_x_chats(
  user_id SERIAL NOT NULL ,
  chat_id SERIAL NOT NULL ,
  admin INTEGER NOT NULL,
  FOREIGN KEY (user_id)
    REFERENCES social_network_db.users(user_id),
  FOREIGN KEY (chat_id)
    REFERENCES social_network_db.chats(chat_id)
);

-- Информация о приложениях и играх
CREATE TABLE social_network_db.games(
  game_id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  creator VARCHAR(255),
  rating INTEGER CHECK ( rating >=0 and rating <= 5 )
);

--Таблица-связка "Пользователи - приложения"
CREATE TABLE social_network_db.users_x_games(
  user_id SERIAL NOT NULL ,
  game_id SERIAL NOT NULL ,
  start_playing DATE NOT NULL,
  FOREIGN KEY (user_id)
    REFERENCES social_network_db.users(user_id),
  FOREIGN KEY (game_id)
    REFERENCES social_network_db.games(game_id)
);

------------------------------------------------------------------
-- Заполнение таблицы "users"
INSERT INTO social_network_db.users(name, birthday, cnt_friends, cnt_groups)
VALUES ('Ензо Гарломи', '1905-03-19', 2, 5),
       ('Градецкая Эльвира', '1998-01-01', 2, 5),
       ('Иванов Иван', '2010-02-14', 2, 3),
       ('Воронин Илья', '1990-01-10', 2, 4),
       ('Пончиков Григорий', '2006-10-15', 3, 5),
       ('Анастасия Сормовская', '2002-10-17', 2, 4),
       ('Огурцов Виталий', '2001-07-29', 1, 7),
       ('Тиньковв Олег', '1967-12-25', 0, 1),
       ('Марк Андреа Месси', '1986-10-22', 2, 3),
       ('Антонио Маргаретти', '1910-12-31', 2, 3),
       ('Доминик Декоко', '1890-09-20', 2, 5);

-- Заполнение таблицы "chats"
INSERT INTO social_network_db.chats(name, cnt_users, privacy, cnt_messages)
VALUES ('Ганс ЛАДНО', 3, 1, 10000),
       ('5А класс', 4, 1, 1293),
       ('Чилл', 3, 1, 6543),
       ('IQ007', 4, 1, 23),
       ('Топ бравлеры 1943', 5, 1, 654),
       ('7-1 Одноимённых братьев-близнецов Рикардо Милоса', 6, 1, 57468),
       ('Потеря потерь', 1, 1, 23134),
       ('Олимпиадный инкубатор 18+', 6, 1, 76),
       ('hustle', 8, 1, 111),
       ('1-ый гвардейский артиллерийский полк имени Д.Васильева', 5, 1, 23298);

-- Заполнение таблицы "groups"
INSERT INTO social_network_db.groups(name, cnt_users, privacy, type, info)
VALUES ('Чадриано Алентано', 3, 2, 'Политика', 'Общество итальяского кинематографа второго рейха'),
       ('9GAG', 10, 1, 'Юмор', 'It does not smell like anything to me'),
       ('TRUE Business', 3, 1, 'Юмор', 'Делаем деньги'),
       ('NR', 8, 1, 'Политика', 'каждый день о том, что нас окружает'),
       ('какой-то паблик с опросами', 5, 1, 'Наука', 'ещё один паблик студентов'),
       ('Поступашки - Олимпиады, ЕГЭ и ДВИ', 7, 1, 'Наука', 'Жить, чтобы ботать; ботать, чтобы жить'),
       ('Клуб Го', 4, 3, 'Наука', 'Учение ~ свет'),
       ('Физтех.Семья', 10, 2, 'Жизнь', 'Нельзя отворачиваться от семьи, даже если она отвернулась от тебя.'),
       ('Философия Романа Липовского', 5, 3, 'Путь', 'Понимаем семантику'),
       ('Хроники краха доллара', 7, 3, 'Политика', '26 марта наши аналитики обнаружили, что доллару остается жить всего два месяца. Данная группа позволит вам следить за тем, с какой пугающей точностью сбываются наши прогнозы');

-- Заполнение таблицы "games"
INSERT INTO social_network_db.games(name, creator, rating)
VALUES ('Блокада', 'NovaLink.Games', 4),
       ('Brawl Gods', 'Supercell', 5),
       ('Doka 2', 'Valve', 1),
       ('CS', 'Valve', 3),
       ('Universe of tanks', 'Wargaming.net', 0),
       ('VL', 'Riot Games', 4),
       ('Need For Speed', 'Electronic Art', 3),
       ('Warlegs', 'Mail.ru', 4),
       ('Worms', 'Team17', 1),
       ('Subway', 'Kiloo ', 2);

-- Заполнение таблицы "friends"
INSERT INTO social_network_db.friends(user_id_1, user_id_2, date_of_start, relation)
VALUES (1, 11, '1930-07-10', 'Коллеги'),
       (1, 10, '1930-07-15', 'Коллеги'),
       (10, 11, '1930-07-12', 'Коллеги'),
       (5, 6, '2015-09-01', 'Влюблённые'),
       (3, 5, '2016-10-15', 'Одноклассники'),
       (3, 4, '2016-09-20', 'Одноклассники'),
       (4, 5, '2016-10-25', 'Одноклассники'),
       (2, 7, '2021-01-25', 'Родственники'),
       (2, 9, '2009-03-15', 'Родственники'),
       (6, 9, '2020-08-18', 'Родственники');

-- Заполнение таблицы "users_x_chats"
INSERT INTO social_network_db.users_x_chats(chat_id, user_id, admin)
VALUES (1, 1, 1), (1, 10, 0), (1, 11, 0),
       (2, 3, 0), (2, 4, 0), (2, 5, 1), (2, 6, 0),
       (3, 9, 1), (3, 7, 0), (3, 5, 0),
       (4, 2, 0), (4, 3, 0), (4, 4, 1), (4, 5, 0),
       (5, 2, 1), (5, 7, 0), (5, 9, 0), (5, 5, 0), (5, 6, 0),
       (6, 2, 1), (6, 7, 0), (6, 9, 0), (6, 5, 0), (6, 6, 0), (6, 4, 1),
       (7, 8, 1),
       (8, 2, 1), (8, 7, 0), (8, 3, 0), (8, 5, 1), (8, 6, 0), (8, 4, 0),
       (9, 2, 0), (9, 7, 0), (9, 3, 0), (9, 5, 1), (9, 6, 0), (9, 4, 0),(9, 9, 1), (9, 10, 0),
       (10, 1, 1), (10, 10, 0), (10, 11, 0), (10, 5, 0), (10, 7, 0);

-- Заполнение таблицы "users_x_groups"
INSERT INTO social_network_db.users_x_groups(user_id, group_id, admin, banned)
VALUES (1, 1, 1, 0), (10, 1, 0, 0), (11, 1, 0, 0),
       (2, 2, 1, 0), (3, 2, 0, 1), (4, 2, 1, 0), (5, 2, 1, 0), (7, 2, 0, 0),
       (9, 3, 1, 0), (7, 3, 0, 0), (6, 3, 0, 0),
       (2, 4, 1, 0), (3, 4, 0, 1), (4, 4, 1, 0), (5, 4, 1, 0), (7, 4, 0, 0), (9, 4, 1, 0), (10, 4, 0, 1), (11, 4, 1, 0),
       (8, 5, 1, 1),
       (1, 6, 1, 0), (3, 6, 0, 1), (4, 6, 1, 0), (2, 6, 1, 0), (7, 6, 0, 0), (11, 6, 0, 1),
       (1, 7, 1, 0), (5, 7, 0, 1), (7, 7, 1, 0), (11, 7, 1, 0),
       (2, 8, 1, 0), (7, 8, 0, 1), (6, 8, 0, 0),
       (1, 9, 0, 0), (6, 9, 1, 0), (9, 9, 0, 1), (5, 9, 1, 0), (7, 9, 0, 0),
       (4, 10, 1, 0), (2, 10, 0, 1), (6, 10, 1, 0), (5, 10, 1, 0), (11, 10, 0, 0), (10, 10, 0, 1), (1, 10, 0, 0);

-- Заполнение таблицы "users_x_games"
INSERT INTO social_network_db.users_x_games(user_id, game_id, start_playing)
VALUES (1, 1, '1930-10-10'), (10, 1, '1925-11-02'), (11, 1, '1940-09-12'), (5, 1, '2015-01-12'),
       (5, 2, '2021-12-16'), (3, 2, '2018-10-12'), (4, 2, '2018-06-21'), (7, 2, '2015-01-12'), (8, 2, '2017-03-17'),
       (4, 3, '2013-02-10'), (9, 3, '2002-02-11'), (11, 3, '2012-04-12'),
       (7, 4, '2020-08-23'),
       (1, 5, '2012-12-30'), (8, 5, '2015-05-12'), (4, 5, '2018-06-21'), (7, 5, '2021-03-23'),
       (2, 6, '2022-03-22'), (3, 6, '2019-05-25'),
       (9, 7, '2021-04-13'),
       (3, 8, '2014-11-11'), (4, 8, '2015-07-16'), (2, 8, '2013-03-22'), (10, 8, '2022-03-23'),
       (4, 9, '2009-11-17'),
       (5, 10, '2020-12-22'), (11, 10, '2019-11-21');

-------------------------------------------------------------------------------
