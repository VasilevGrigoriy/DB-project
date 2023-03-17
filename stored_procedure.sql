---------------------------------------------------------------------------------
-- ХРАНИМЫЕ ПРОЦЕДУРЫ

-- (1) Функция, удаляющая человека из друзей; на вход подается два пользователя (их name).
--     После чего все упоминания о их содружестве удаляются: уменьшаются счетчики cnt_friends,
--     из таблицы friends удаляется информация о их дружбе.
CREATE OR REPLACE FUNCTION social_network_db.func_remove_friendship(user1 INTEGER, user2 INTEGER) RETURNS void AS
    $$
    UPDATE social_network_db.users
    SET cnt_friends = cnt_friends - 1
    WHERE user_id = user1 or user_id = user2;
    DELETE from social_network_db.friends
    where (user_id_1 = user1 and user_id_2 = user2) or
          (user_id_1 = user2 and user_id_2 = user1);
    $$ LANGUAGE SQL;

SELECT social_network_db.func_remove_friendship(1, 11);
DROP FUNCTION social_network_db.func_remove_friendship(user1 INTEGER, user2 INTEGER);

-- (2) Функция для бана определенного пользователя в группе: проставляет поле banned = 1
--     в таблице users_x_groups, а также уменьшает количеству групп на 1 у пользователя и у группы.
CREATE OR REPLACE FUNCTION social_network_db.func_ban_user(usr INTEGER, grp INTEGER) RETURNS void AS
    $$
    UPDATE social_network_db.users_x_groups
    SET banned = 1
    WHERE user_id = usr and group_id = grp;
    UPDATE social_network_db.users
    SET cnt_groups = cnt_groups - 1
    WHERE user_id = usr;
    UPDATE social_network_db.groups
    SET cnt_users = cnt_users - 1
    WHERE group_id = grp;
    $$ LANGUAGE SQL;

SELECT social_network_db.func_ban_user(1, 1);
DROP FUNCTION social_network_db.func_ban_user(usr INTEGER, grp INTEGER);

