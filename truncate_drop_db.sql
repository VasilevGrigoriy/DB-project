-- Удаление значений из таблицы
TRUNCATE
    social_network_db.users,
    social_network_db.chats,
    social_network_db.groups,
    social_network_db.games,
    social_network_db.users_x_chats,
    social_network_db.users_x_groups,
    social_network_db.users_x_games,
    social_network_db.friends;

-- Удаление таблиц
DROP TABLE
    social_network_db.users,
    social_network_db.chats,
    social_network_db.groups,
    social_network_db.games,
    social_network_db.users_x_chats,
    social_network_db.users_x_groups,
    social_network_db.users_x_games,
    social_network_db.friends;

-- Удаление схемы
DROP SCHEMA social_network_db
