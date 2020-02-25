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
	prm_type VARCHAR,
	prm_collected MONEY
)

INSERT INTO @tbl_client
	(cli_id, cli_fio) VALUES
	(1,		'Михаил'),
	(2,		'Александр')

INSERT INTO @tbl_contract
	(cnt_id, cnt_client, cnt_number)
VALUES
	--Контракты Михаила
    (1, 	 1, 		 'A'),
    (2,      1, 		 'B'),
    --Контракты Александра
	(3, 	 2, 		 'C'),
	(4,      2, 		 'D')

INSERT INTO @tbl_premium
	(prm_id, prm_contract, prm_type, prm_collected) 
VALUES
	--Премии/возвраты Михаила
  	
	(1,      1,            'R', 	   100),
	-- + Премия Михаила, учитываем
  	(2,      2,            NULL, 	   100),

	--Премии/возвраты Александра
 	
	(3,      3,            'R', 	   200),
  	-- + Премия Александра, учитываем
	(4,      4,            NULL, 	   200),

	--Премии/возвраты Михаила
  	
	(5,      1,            'R', 	   300),
  	-- + Премия Михаила, учитываем
	(6,      2,            NULL,       300),

	--Премии/возвраты Александра

  	(7,      3,            'R',        400),
	-- + Премия Александра, учитываем
  	(8,      4,            NULL,       400)

--Проверим, что у Михаила общая сумма оплаченных премий 400 р, а у Александра - 600 р
SELECT
	cl.cli_fio, SUM(p.prm_collected) AS [TotalPremium]
	FROM @tbl_client cl
		LEFT JOIN @tbl_contract ct
			ON ct.cnt_client = cl.cli_id
		LEFT JOIN @tbl_premium p
			ON p.prm_contract = ct.cnt_id
	WHERE p.prm_type IS NULL
GROUP BY cl.cli_id, cl.cli_fio