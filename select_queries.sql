-- (1) GROUP BY + HAVING
with u_c as (
    select *
    from social_network_db.users_x_chats as uc
    inner join social_network_db.users u on uc.user_id = u.user_id
)
select chat_id, avg(cnt_groups)
from u_c
group by chat_id
having count(*) > 1;
-- В результате данного запроса для каждой группы выведется
-- среднее количество групп участников данной группы.
-- Группы будут учтены и выведены, если в ней больше 1 человека.

-- (2) ORDER BY
select name, cnt_friends, cnt_groups
from social_network_db.users
order by cnt_friends, cnt_groups;

-- В результате данного запроса будет выведен список пользователей,
-- отсортированный по количеству друзей, а после по количеству подписок
-- Будут выведены: имя пользователяб количество друзейб количество подписок.

-- (3) func() OVER(): PARTITION BY
with u_g as (
    select *
    from social_network_db.users_x_games as ug
    inner join social_network_db.users u on ug.user_id = u.user_id
)
select game_id, name, avg(cnt_friends) over (partition by game_id)
from u_g;

-- В результате данного запроса будет найдено среднее количество друзей
-- у всех пользователей по каждому приложению.
-- Будут выведены: приложение, имя игрока, среднее количеств друзей по приложению.

-- (4) func() OVER(): ORDER BY
select name, type, dense_rank() over (order by cnt_users) as pos
from social_network_db.groups;

-- В результате запроса получим сортировку групп по количеству участников
-- Группы с одинаковым количеством участников получают одинаковый номер в последовательности
-- Вывод: название группы, тип группы, позиция группы в сортировке.

-- (5) func() OVER: ORDER BY + PARTITION BY
select distinct type, avg(cnt_users) over (partition by type)
from social_network_db.groups
order by avg(cnt_users) over (partition by type) DESC;

-- В результате запроса получим сортировку типов групп по среднему количеству
-- участников во всех группах этого типа.
-- Вывод: тип группы, среднее по типу количество участников

-- (6) func() OVER: GROUP BY + HAVING + ORDER BY + AVG
with avg_games as (
    select creator, avg(rating) as rating
    from social_network_db.games
    group by creator
    having avg(rating) > 0
)
select creator, dense_rank() over (order by rating) as pos
from avg_games;

-- В результате получим таблицу создателей игр, отсортированных
-- по среднему рейтингу игр от этого производителя.
-- В результате получим: имя производителя, позиция в рейтинге.
