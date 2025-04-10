-- ========== PREPARING DATA FOR ANALYSIS ==========

-- STEP 1: We will first remove duplicates using 'DISTINCT' and remove any rows without a Customer ID. We will
-- also introduce a new column row_id that is unique for each row, since there are no unique columns in our data
-- set.

WITH sales AS (
  SELECT *,
    ROW_NUMBER() OVER () AS row_id
  FROM (
    SELECT DISTINCT *
    FROM retail_sales
    WHERE customerid IS NOT NULL
  	) AS deduped
),

-- STEP 2: We will further check for NULLS in all columns:

-- SELECT
--     COUNT(*) AS total_rows,
--     SUM(CASE WHEN invoiceno IS NULL THEN 1 ELSE 0 END) AS invoiceno_nulls,
--     SUM(CASE WHEN stockcode IS NULL THEN 1 ELSE 0 END) AS stockcode_nulls,
--     SUM(CASE WHEN description IS NULL THEN 1 ELSE 0 END) AS description_nulls,
-- 	SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS quantity_nulls,
-- 	SUM(CASE WHEN invoicedate IS NULL THEN 1 ELSE 0 END) AS invoicedate_nulls,
-- 	SUM(CASE WHEN unitprice IS NULL THEN 1 ELSE 0 END) AS unitprice_nulls,
-- 	SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_nulls
-- FROM sales;

-- No NULLS were found.



	
-- STEP 3: The data set contains records of returned items that contains negative quantities and their invoice
-- number starts with the letter 'C'. We will find these records and their corresponding buy records. If a
-- return record does not have a corresponding buy record, then it is an 'Orphan Return' and we need to remove
-- it from our data set.

-- First we will retrieve the total cancelled orders.

total_cancelled_orders AS (
  SELECT *
  FROM sales
  WHERE invoiceno LIKE 'C%'
    AND quantity < 0
),

-- Now, we will retrieve the "Orphan Returns" out of the total cancelled orders.	

total_orphan_returns AS (
  SELECT *
  FROM total_cancelled_orders tco
  WHERE NOT EXISTS (
    SELECT 1
    FROM sales b
    WHERE tco.customerid = b.customerid
      AND tco.stockcode = b.stockcode
      AND tco.description = b.description
      AND -tco.quantity = b.quantity
      AND tco.invoicedate >= b.invoicedate
      AND tco.unitprice = b.unitprice
      AND tco.country = b.country
      AND b.invoiceno NOT LIKE 'C%'
  )
),

-- Finally we will remove these "Orphan Returns" from our data set.
	

clean_sales AS (
  SELECT *
  FROM sales s
  WHERE NOT EXISTS (
    SELECT 1
	FROM total_orphan_returns tor
	WHERE s.row_id = tor.row_id
	)
),

-- Now our data is ready for RFM Analysis


	

-- ========== PERFORMING RFM ANALYSIS ===========

max_date AS (
  SELECT MAX(invoicedate) + INTERVAL '1 day' AS reference_date
  FROM clean_sales
),

rfm_base AS (
  SELECT 
    customerid,
    MAX(invoicedate) AS last_purchase,
    COUNT(DISTINCT invoiceno) AS frequency,
    SUM(unitprice * quantity) AS monetary,
    EXTRACT(DAY FROM b.reference_date - MAX(a.invoicedate)) AS recency
  FROM clean_sales a
  CROSS JOIN max_date b
  GROUP BY customerid, b.reference_date
),

rfm_scores AS (
  SELECT
    customerid,
	recency,
	frequency,
	monetary,
	NTILE(5) OVER (ORDER BY recency DESC) AS r_score,
	NTILE(5) OVER (ORDER BY frequency ASC) AS f_score,
	NTILE(5) OVER (ORDER BY monetary ASC) AS m_score,
	  CAST(
	    CONCAT(
	      NTILE(5) OVER (ORDER BY recency DESC),
	      NTILE(5) OVER (ORDER BY frequency ASC),
	      NTILE(5) OVER (ORDER BY monetary ASC)
		) AS INT
	  ) AS rfm_score
	
  FROM rfm_base
),

rfm_segments AS (
  SELECT *,
    CASE
	  WHEN rfm_score in (555, 554, 544,
		545, 454, 455, 445)
		THEN 'Champions'
	
	  WHEN rfm_score in (543, 444, 435,
		355, 354, 345, 344, 335)
		THEN 'Loyal'
	
	  WHEN rfm_score in (553, 551, 552,
		541, 542, 533, 532, 531, 452,
		451, 442, 441, 431, 453, 433,
		432, 423, 353, 352, 351, 342,
		341, 333, 323)
		THEN 'Potential Loyalist'
	
	  WHEN rfm_score in (512, 511, 422,
		421, 412, 411, 311)
		THEN 'New Customers'
	
	  WHEN rfm_score in (525, 524, 523,
		522, 521, 515, 514, 513, 425,
		424, 413, 414, 415, 315, 314,
		313)
		THEN 'Promising'
	
	  WHEN rfm_score in (535, 534, 443,
		434, 343, 334, 325, 324)
		THEN 'Need Attention'
	
	  WHEN rfm_score in (331, 321, 312,
		221, 213, 231, 241, 251)
		THEN 'About To Sleep'
	
	  WHEN rfm_score in (155, 154, 144,
		214, 215, 115, 114, 113)
		THEN 'Cannot Lose'
	
	  WHEN rfm_score in (255, 254, 245,
		244, 253, 252, 243, 242, 235,
		234, 225, 224, 153, 152, 145,
		143, 142, 135, 134, 133, 125,
		124)
		THEN 'At Risk'
	
	  WHEN rfm_score in (332, 322, 233,
		232, 223, 222, 132, 123, 122,
		212, 211)
		THEN 'Hibernating'
	
	  WHEN rfm_score in (111, 112, 121,
		131, 141, 151)
		THEN 'Lost'
	
      ELSE 'Others'
	
	END AS segment
  FROM rfm_scores
),

countries AS (
  SELECT
    DISTINCT customerid,
	MIN(country) AS country
  FROM sales
  GROUP BY customerid
),
	
final_sales AS (
SELECT
  a.*,
  b.country
FROM rfm_segments a
LEFT JOIN countries b
	ON a.customerid = b.customerid
)

SELECT *
FROM final_sales
;
