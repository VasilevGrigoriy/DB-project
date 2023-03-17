-- (1) Представление групп, те, которые имеют приватность >= 2,
-- спрячем про неё частную информацию
create view social_network_db.groups_view as
select name, privacy,
       case when privacy = 1 then cnt_users else -1 end as cnt_users,
       case when privacy = 1 then type else 'not visible' end as type,
       case when privacy = 1 then info else 'not visible' end as info
from social_network_db.groups;

drop view social_network_db.groups_view;

-- (2) Представление чатов, те, которые имеют приватность >= 2,
-- -- спрячем про неё частную информацию
create view social_network_db.chats_view as
select name, privacy,
       case when privacy = 1 then cnt_users else -1 end as cnt_users,
       case when privacy = 1 then cnt_messages else -1 end as cnt_messages
from social_network_db.chats;

drop view social_network_db.chats_view;

-- (3) Получим представление чатов и пользователей:
--     получим вид имя пользователя - название чата, в котором пользователь состоит,
--     и отсортируем по чатам, чтобы явно было видно всех пользователей чата.
create view social_network_db.chats_users as
select u.name as user_name, u_c.chat as chat
from
    (
        select c.name as chat, u_c.user_id
        from social_network_db.users_x_chats as u_c
        inner join social_network_db.chats c on c.chat_id = u_c.chat_id
    ) as u_c
inner join social_network_db.users u on u_c.user_id = u.user_id
order by chat;

drop view social_network_db.chats_users;

-- (4) Получим представление чатов и пользователей:
--     получим вид имя пользователя - название группы, в котором пользователь состоит,
--     и отсортируем по группам, чтобы явно было видно всех пользователей группы.
create view social_network_db.groups_users as
select u.name as user_name, u_g.group_name as group_name
from
    (
        select g.name as group_name, u_g.user_id
        from social_network_db.users_x_groups as u_g
        inner join social_network_db.groups g on g.group_id = u_g.group_id
    ) as u_g
inner join social_network_db.users u on u_g.user_id = u.user_id
order by group_name;

drop view social_network_db.groups_users;

-- (5) Получим представление игр и пользователей:
--     получим вид имя пользователя - название игры, в котором пользователь состоит,
--     и отсортируем по играм, чтобы явно было видно всех пользователей игр.
create view social_network_db.games_users as
select u.name as user_name, u_g.game as game
from
    (
        select g.name as game, u_g.user_id
        from social_network_db.users_x_games as u_g
        inner join social_network_db.games g on g.game_id = u_g.game_id
    ) as u_g
inner join social_network_db.users u on u_g.user_id = u.user_id
order by game;

drop view social_network_db.games_users;

-- (6) Получим представление друзей через имена пользователей
create view social_network_db.friends_names as
select f.name as person_1, u.name as person_2
from
    (
        select f.user_id_2 as user_id_2, u.name
        from social_network_db.friends as f
        inner join social_network_db.users u on f.user_id_1 = u.user_id
    ) as f
inner join social_network_db.users u on f.user_id_2 = u.user_id
order by person_1;

drop view social_network_db.friends_names;
