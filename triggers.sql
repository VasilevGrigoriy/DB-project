---------------------------------------------------------------------------------
-- ТРИГГЕРЫ

-- (1) Сделаем триггер, который будет автоматически при добавление в таблицу friend
--     новою информацию о друзьях увеличивать счетчики количества друзей у user_id_1 и user_id_2 новой записи.
CREATE OR REPLACE FUNCTION social_network_db.trigger_autoinc_friends() RETURNS TRIGGER as
    $$
    BEGIN
        IF (TG_OP = 'INSERT') THEN
            UPDATE social_network_db.users
            SET cnt_friends = cnt_friends + 1
            WHERE user_id = NEW.user_id_1 or user_id = NEW.user_id_2;
            RETURN NEW;
        end if;
    end;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_friends
AFTER INSERT ON social_network_db.friends
FOR EACH ROW
EXECUTE PROCEDURE social_network_db.trigger_autoinc_friends();

-- Проверим обработку добавления в друзья:
INSERT INTO social_network_db.friends(user_id_1, user_id_2, date_of_start, relation)
VALUES (2, 6, '2022-05-08', 'Друзья');

DROP TRIGGER trigger_friends ON social_network_db.friends;
DROP FUNCTION social_network_db.trigger_autoinc_friends();

-- (2) Сделаем триггер, который обладает следующим функционалом: если пользователь
--     начинает играть в любую игру от creator Valve, то он автоматически подписывается
--     на группу 9GAG (вот такой вот прикол, часто со мной бывало).
--     То есть при добавилении в таблицу users_x_games новой строчки, в которой индекс игры
--     принадлежит множетсву индексов игр от Valve, мы также добавляем в таблицу users_x_groups
--     поле подписки на группу 9GAG (если её еще не было) и увеличивыем все счетчики.

CREATE OR REPLACE FUNCTION social_network_db.trigger_valve_player() RETURNS TRIGGER as
    $$
    BEGIN
        IF (TG_OP = 'INSERT') THEN
            IF (NEW.game_id in (select game_id from social_network_db.games where creator = 'Valve')) THEN
                IF (0 in (select count(*) from social_network_db.users_x_groups where user_id = NEW.user_id and group_id in (select group_id from social_network_db.groups where name = '9GAG'))) THEN
                    INSERT INTO social_network_db.users_x_groups(user_id, group_id, admin, banned)
                    VALUES (NEW.user_id, (select group_id from social_network_db.groups where name = '9GAG'), 0, 0);
                    UPDATE social_network_db.groups
                    SET cnt_users = cnt_users + 1
                    WHERE name = '9GAG';
                end if;
                UPDATE social_network_db.users
                SET cnt_groups = cnt_groups + 1
                WHERE user_id = NEW.user_id;
                RETURN NEW;
            end if;
        end if;
    end;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_valve_games
AFTER INSERT ON social_network_db.users_x_games
FOR EACH ROW
EXECUTE PROCEDURE social_network_db.trigger_valve_player();

-- Проверим обработку добавления в друзья:
INSERT INTO social_network_db.users_x_games(user_id, game_id, start_playing)
VALUES (1, 4, '2022-05-08');
INSERT INTO social_network_db.users_x_games(user_id, game_id, start_playing)
VALUES (1, 3, '2022-05-08');

DROP TRIGGER trigger_valve_games ON social_network_db.users_x_games;
DROP FUNCTION social_network_db.trigger_valve_player();
