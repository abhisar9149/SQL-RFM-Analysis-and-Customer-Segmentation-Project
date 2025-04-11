

# 📊 SQL-Automated RFM Analysis and Customer Segmentation Project

**Author**: Abhisar Sharma  
**Email**: abhisars117@gmail.com  

This project performs a complete **RFM (Recency, Frequency, Monetary)** analysis on e-commerce customer data to identify and segment key customer groups.

It demonstrates a full data analysis workflow:

- 🧹 Data cleaning with **Python**
- 🛢️ Data storage and querying with **PostgreSQL**
- 🧮 Customer scoring and segmentation using **SQL**
- 📈 Visual insights via **Power BI** with **automated refresh**

### 📊 What is RFM analysis?

RFM (Recency, Frequency, Monetary) is a customer segmentation technique that ranks customers based on:

- **Recency:** How recently they purchased
- **Frequency:** How often they purchase
- **Monetary:** How much they spend

---

## 🛠️ Tools & Technologies

- Python (Pandas, Jupyter Notebook)  
- PostgreSQL  
- SQL  
- Power BI

---

## 📂 Dataset

- **Source**: [Kaggle – Ecommerce Data](https://www.kaggle.com/datasets/carrie1/ecommerce-data/)
- **Rows**: 541,909  
- **Size**: ~45.5 MB  
- **Columns**:
  - `InvoiceNo`, `StockCode`, `Description`, `Quantity`, `InvoiceDate`, `UnitPrice`, `CustomerID`, `Country`

---

## 🔄 Project Workflow

1. **Data Preprocessing (Python)**
   - Standardized column names
   - Cleaned and formatted datetime column
   - Exported cleaned CSV

2. **Data Storage (PostgreSQL)**
   - Created a new table and imported the cleaned CSV using `pgAdmin`

3. **Data Cleaning in SQL**
   - Removed duplicates and NULL values
   - Excluded “Orphan Returns” (returns without a matching purchase)

4. **RFM Analysis (SQL)**
   - Calculated Recency, Frequency, and Monetary values
   - Applied quantile-based scoring
   - Segmented customers based on RFM scores

5. **Visualization (Power BI)**
   - Created an interactive dashboard with slicers and metrics
   - Used DAX for segment-wise insights
   - Published report and **automated refresh using Power BI Service**

---

## 🚀 How to Use This Project

1. **Clone the Repository**  
   Clone this GitHub repository to your local machine using:

   ```
   git clone https://github.com/abhisar9149/SQL-RFM-Analysis-and-Customer-Segmentation-Project.git
   ```

2. **Download the Dataset**  
   - Go to [Kaggle – Ecommerce Data](https://www.kaggle.com/datasets/carrie1/ecommerce-data/)
   - Download the dataset
   - Place the CSV file inside the project folder

3. **Preprocess the Data (Python)**  
   - Open the provided Python notebook/script
   - This script:
     - Standardizes column names
     - Fixes date/time formats (`InvoiceDate`)
     - Outputs `cleaned_data.csv`

4. **Import Data into PostgreSQL**  
   - Launch pgAdmin and connect to your database
   - Create a new table with 8 columns matching the dataset
   - Import the cleaned CSV using pgAdmin or the `COPY` SQL command

5. **Run SQL Script for RFM Analysis**  
   - Open `ecommerce_data_rfm_analysis.sql` in pgAdmin’s query tool
   - Execute the SQL queries to:
     - Clean and transform the data
     - Calculate RFM metrics
     - Segment customers

6. **Open Power BI Dashboard**  
   - Open the `.pbix` file provided in the repo
   - Update the data source to your PostgreSQL connection
   - Refresh the data to reflect your database results

## Screenshots

![image alt](https://github.com/abhisar9149/SQL-RFM-Analysis-and-Customer-Segmentation-Project/blob/37b03690cab06c84ae82225b9b0572e1a7576613/screenshots/Screenshot%202025-04-10%20150821.png)  

![image alt](https://github.com/abhisar9149/SQL-RFM-Analysis-and-Customer-Segmentation-Project/blob/main/screenshots/Screenshot%202025-04-10%20150730.png))

