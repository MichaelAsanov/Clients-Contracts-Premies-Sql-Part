-- 1.

SELECT * FROM tbl_client cl
	WHERE EXISTS 
	(
		SELECT * FROM tbl_contract ct
			WHERE ct.cnt_client = cl.cli_id
			AND NOT EXISTS 
			(
				SELECT * FROM tbl_premium p
					WHERE p.prm_contract = ct.cnt_id
					AND p.prm_type IS NULL
			)
	)
	
-- 2.
SELECT
	cl.cli_fio, SUM(p.prm_collected) AS [TotalPremium]
	FROM tbl_client cl
		LEFT JOIN tbl_contract ct
			ON ct.cnt_client = cl.cli_id
		LEFT JOIN tbl_premium p
			ON p.prm_contract = ct.cnt_id
	WHERE p.prm_type IS NULL
GROUP BY cl.cli_id, cl.cli_fio

-- 3.
SELECT * FROM tbl_contract ct
	WHERE YEAR(ct.cnt_date) = 2018
		AND NOT EXISTS
		(
			SELECT * FROM tbl_premium p
				WHERE p.prm_contract = ct.cnt_id
					AND p.prm_type IS NULL
					AND p.prm_collected IS NOT NULL
		)
		
-- 4.
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