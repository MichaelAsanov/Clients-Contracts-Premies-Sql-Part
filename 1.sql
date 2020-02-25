DECLARE @tbl_client TABLE
	(
		cli_id INT,
		cli_fio VARCHAR(MAX)
	)

DECLARE @tbl_contract TABLE
(
	cnt_client INT,
 	cnt_id INT,
   	cnt_number VARCHAR
 )

DECLARE @tbl_premium TABLE
(
	prm_id INT,
	prm_contract INT,
	prm_type VARCHAR
)

INSERT INTO @tbl_client
	(cli_id, cli_fio) VALUES
	(1,		'Михаил'),
	(2,		'Александр')

INSERT INTO @tbl_contract
	(cnt_id,  cnt_client,  cnt_number)
	 VALUES
	--У Михаила - первые два контракта...
	 (1,	  1, 	 	   'A'),
	 (2, 	  1, 	 	   'B'),
	-- 3-й - у Александра
	 (3,      2, 	 	   'C')

INSERT INTO @tbl_premium	
	  (prm_id, prm_contract, prm_type) VALUES
	  (1,      1,            'R'),
	  -- У Михаила первый контракт оплачен - находим начисленную премию
	  (2,      1,            NULL),
		
	  -- У Михаила 2-й контракт не оплачен, т. к. у него не находим премии, одни возвраты
	  (3,      2,            'R'),
	  (4,      2,            'R'),
	
	  -- 3-й контракт у Александра оплачен, больше у него контрактов нет
	  (5,      3,            NULL),
	  (6,      3,            NULL)		

-- Проверим, что выведется только Михаил
SELECT * FROM @tbl_client cl
	WHERE EXISTS 
	(
		SELECT * FROM @tbl_contract ct
			WHERE ct.cnt_client = cl.cli_id
			AND NOT EXISTS 
			(
				SELECT * FROM @tbl_premium p
					WHERE p.prm_contract = ct.cnt_id
					AND p.prm_type IS NULL
			)
	)