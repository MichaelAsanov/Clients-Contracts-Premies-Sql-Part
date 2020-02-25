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
	(1,		'������'),
	(2,		'���������')

INSERT INTO @tbl_contract
	(cnt_id,  cnt_client,  cnt_number)
	 VALUES
	--� ������� - ������ ��� ���������...
	 (1,	  1, 	 	   'A'),
	 (2, 	  1, 	 	   'B'),
	-- 3-� - � ����������
	 (3,      2, 	 	   'C')

INSERT INTO @tbl_premium	
	  (prm_id, prm_contract, prm_type) VALUES
	  (1,      1,            'R'),
	  -- � ������� ������ �������� ������� - ������� ����������� ������
	  (2,      1,            NULL),
		
	  -- � ������� 2-� �������� �� �������, �. �. � ���� �� ������� ������, ���� ��������
	  (3,      2,            'R'),
	  (4,      2,            'R'),
	
	  -- 3-� �������� � ���������� �������, ������ � ���� ���������� ���
	  (5,      3,            NULL),
	  (6,      3,            NULL)		

-- ��������, ��� ��������� ������ ������
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