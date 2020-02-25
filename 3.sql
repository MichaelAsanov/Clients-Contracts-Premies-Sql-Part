DECLARE @tbl_contract TABLE
(
    cnt_id INT,
    cnt_number VARCHAR,
	cnt_date DATE
)

DECLARE @tbl_premium TABLE
(
	prm_id INT,
	prm_contract INT,
	prm_type VARCHAR,
	prm_collected MONEY
)

INSERT INTO @tbl_contract
(	cnt_id, 	cnt_date, 	cnt_number )
VALUES
(	1, 			'20180101', 'A'),
(	2, 			'20180102', 'B'),

(	3, 			'20190102', 'C')

-- Пусть у контракта с ID 1 (от 01.01.18 нет оплаты)
INSERT INTO @tbl_premium
(
	prm_id, prm_contract, prm_type,	prm_collected
)
VALUES
	--1-й контракт - не оплачен, у него две premium,
	--1-й premium - премия, но не заполнен prm_collected
	--2-q premium - возврат
	(1,     1,            NULL,     NULL),
	(2,     1,            'R',      100),

	--2-й контракт - 2018-го года, есть оплата, 
	(3,     2,            NULL,     200),

	--3-й контракт - 2019-го года
	(4,     3,            NULL,     300)

--Проверим, что выведется только первый контракт
SELECT * FROM @tbl_contract ct
	WHERE YEAR(ct.cnt_date) = 2018
		AND NOT EXISTS
		(
			SELECT * FROM @tbl_premium p
				WHERE p.prm_contract = ct.cnt_id
					AND p.prm_type IS NULL
					AND p.prm_collected IS NOT NULL
		)



