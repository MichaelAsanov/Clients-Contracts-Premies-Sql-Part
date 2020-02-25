DECLARE @tbl_contract TABLE
(
	cnt_id INT,
	cnt_number VARCHAR
)

DECLARE @tbl_premium TABLE
(
   prm_id INT,
   prm_contract INT,
   prm_type VARCHAR
)

 INSERT INTO @tbl_contract
	(cnt_id, cnt_number) 
	VALUES
	(1, 	'A'),
	(2, 	'B'),
	(3, 	'C'),
	(4, 	'D')

INSERT INTO @tbl_premium
  (prm_id, prm_contract, prm_type) VALUES  
		
  (1,      1,            'R'), 
  --Последний возврат контракта A (по ID) - удаляем 
  (2,      1,            'R'),
  (3,      1,            NULL),  
  (4,      1,            NULL),

  (5,      2,            'R'), 
  --Последний возврат контракта B (по ID) - удаляем 
  (6,      2,            'R'),
  (7,      2,            NULL),  
  (8,      2,            NULL),

  (9,      3,            'R'), 
  --Последний возврат контракта C (по ID) - удаляем 
  (10,      3,            'R'),
  (11,      3,            NULL),  
  (12,      3,            NULL),

  -- Контракт D, здесь ничего не удаляем
  (13,      4,            'R'),
  (14,      4,            'R'),
  (15,      4,            NULL),
  (16,      4,            NULL)
;

--Проводим удаление
WITH p1 (prm_id, [Rank])
AS 
(
	SELECT p.prm_id,
	DENSE_RANK() OVER (PARTITION BY p.prm_contract ORDER BY p.prm_id DESC) AS [Rank]
	FROM @tbl_premium p
	WHERE 
		p.prm_type = 'R'
		AND p.prm_contract IN 
		(
			SELECT c.cnt_id FROM @tbl_contract c 
				WHERE c.cnt_number IN ('A', 'B', 'C')
		)
)
DELETE FROM p1 WHERE [Rank]=1

--Проверим, что удалились 3 возврата - с ID 2, 6, 10; осталось 13 записей 
SELECT * FROM @tbl_premium
	ORDER BY prm_id
    

