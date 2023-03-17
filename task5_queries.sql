-- (1) Получим информацию по всем пользователям
select * from social_network_db.users;


-- (2) Получим все игры и их рейтинг
select g.name, g.rating
from social_network_db.games as g;


-- (3) Получим всех друзей Доминика Декоко
with
     dom_decoco as (
         select u.user_id
         from social_network_db.users as u
         where u.name = 'Доминик Декоко'
     ),
     d_d_fr as (
         select case
                    when f.user_id_1 = (select * from dom_decoco) then f.user_id_2
                    else f.user_id_1 end
         from social_network_db.friends as f
         where f.user_id_1 in (select * from dom_decoco)
            or f.user_id_2 in (select * from dom_decoco)
     )
select u.name
from social_network_db.users as u
where u.user_id in (select * from d_d_fr);


-- (4) Получим все группы с >= 5 подписчиками
select g.name
from social_network_db.groups as g
where g.cnt_users >= 5;


-- (5) Получим всех пользователей, которые являются
------ админами хотя бы в 1 группе
with admins as (
    select g.user_id
    from social_network_db.users_x_groups as g
    where g.admin = 1
)
select u.name
from social_network_db.users as u
where u.user_id in (select * from admins);


-- (6) Обновим в таблице games информацию про игру Universe of tanks,
--     увеличив ей рейтинг до 4
update social_network_db.games
set rating = 4
where name = 'Universe of tanks';


-- (7 - 8) Теперь вовсе удалим информацию о игре Universe of tanks,
--     а также всю информацию с ней из таблицы users_x_games
delete from social_network_db.users_x_games
where game_id in (
    select g.game_id
    from social_network_db.games as g
    where g.name = 'Universe of tanks');

delete from social_network_db.games
where name = 'Universe of tanks';


-- (9 - 10) Обновим количество друзей у Тиньковва Олега до 1,
--          пусть он начнет дружить с Огурцовым Виталием, коллеги
update social_network_db.users
set cnt_friends = 1
where name = 'Тиньковв Олег';

insert into social_network_db.friends(user_id_1, user_id_2, date_of_start, relation)
VALUES (
        (select user_id from social_network_db.users where name = 'Тиньковв Олег'),
        (select user_id from social_network_db.users where name = 'Огурцов Виталий'),
        '2022-04-25',
        'Коллеги'
        );
