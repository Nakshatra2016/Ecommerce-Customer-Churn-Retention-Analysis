# 📊 E-Commerce Customer Churn, Cohort Retention & RFM Analysis

![Business Analytics](https://img.shields.io/badge/Domain-Business%20Analytics-blue?style=for-the-badge)
![SQL](https://img.shields.io/badge/Language-SQL%20(PostgreSQL)-orange?style=for-the-badge)
![Python](https://img.shields.io/badge/Analytics-Python%20(Pandas)-brightgreen?style=for-the-badge)
![Power BI](https://img.shields.io/badge/Visualization-Power%20BI%20%2F%20Excel-yellow?style=for-the-badge)
![Author](https://img.shields.io/badge/Author-Nakshatra%20Khanna-purple?style=for-the-badge)

---

## 📌 Executive Summary
Customer acquisition costs (CAC) in modern e-commerce platforms have increased by over 45% in recent years, making **customer retention** and **repeat purchase frequency** paramount to profitability. 

This project provides an end-to-end business analysis of customer churn across **1,200 transactions** totaling **₹1.10 Crore in gross revenue**. By implementing **Cohort Retention Analysis** and a **Recency-Frequency-Monetary (RFM) Segmentation Model**, this study uncovers the critical drivers of customer drop-off and formulates data-backed retention interventions for product and marketing stakeholders.

---

## 🎯 Business Problem Statement
* **High First-Order Drop-off:** Over **78% of customers** did not make a repeat purchase within 60 days following their initial order.
* **Lack of Customer Segmentation:** Marketing sent uniform broadcast discount emails rather than segmenting users by purchase recency and customer lifetime value (LTV).
* **Objective:**
  1. Measure true retention curves month-over-month using SQL cohort modeling.
  2. Segment 380 unique customer accounts into 4 actionable behavioral profiles.
  3. Formulate targeted business strategies to cut churn by 15% and protect high-LTV accounts.

---

## 🛠️ Analytics Tech Stack
* **Database & Querying:** SQL (PostgreSQL) — Common Table Expressions (`WITH`), Window Functions (`NTILE`, `LAG`, `ROW_NUMBER`), Multi-table Joins, Cohort Grouping.
* **Data Processing & Modeling:** Python (Pandas, NumPy) for RFM quantile scoring and summary distributions.
* **Business Documentation:** Business Requirement Document (BRD) & Functional Specifications.
* **Visualization:** Power BI & MS Excel (Pivot Tables, Dynamic KPI Cards).

---

## 📈 Key Findings & Business Insights

### 1. RFM Behavioral Segmentation Breakdown
| Customer Segment | % of Customer Base | Characteristics | Business Strategy |
| :--- | :---: | :--- | :--- |
| **Champions (High Loyalty)** | **32.4%** | Highly recent, high order frequency & value | VIP loyalty rewards, early product drops, no heavy discounts needed. |
| **Promising (New Shoppers)** | **18.2%** | Recent first purchases, low frequency | Onboarding drip emails, category discovery vouchers within Day 7–14. |
| **At Risk (High LTV / Inactive)** | **17.6%** | Historically high spenders, inactive >60 days | Re-engagement SMS/WhatsApp with personalized "We Miss You" perks. |
| **Hibernating / Churned** | **31.8%** | Long period of inactivity, low repeat rate | Win-back campaign with clearance promos; cap paid ad re-targeting to save budget. |

### 2. Category Performance & Churn Correlation
* **Books & Beauty:** Exhibited the highest churn rates (~80.5% – 83.3%), despite strong gross revenue. Customers often buy single gift or seasonal items without repurchasing.
* **Apparel & Home/Kitchen:** Showed the highest repeat retention (~23.8% repeat buyers), making them the primary anchor categories for subscription/loyalty bundling.

---

## 💡 Strategic Recommendations for Stakeholders

1. **Automate Post-Purchase Trigger Workflows:** Trigger a personalized product recommendation email on **Day 10 post-delivery** (before the 60-day churn threshold is reached).
2. **Re-allocate Marketing Budget:** Divert 25% of top-of-funnel acquisition ad spend toward retention campaigns targeting the **17.6% "At Risk" segment**, preventing high-value revenue leakage.
3. **Loyalty & Gamification:** Introduce tiered loyalty points for repeat orders within 30 days to incentivize faster purchase cycles.

---

## 📂 Repository File Structure
```
├── customer_churn_analysis.sql    # Complete SQL script (KPIs, Cohorts, RFM)
├── churn_analysis.py              # Automated Python data modeling pipeline
├── sample_ecommerce_data.csv      # Raw transaction dataset (1,200 records)
├── Executive_Project_Report.pdf   # 2-Page Executive Presentation for Stakeholders
└── README.md                      # Comprehensive project documentation
```

---

## 🚀 How to Run the Analysis Locally
1. Clone the repository:
   ```bash
   git clone https://github.com/Nakshatra2016/Ecommerce-Customer-Churn-Retention-Analysis.git
   cd Ecommerce-Customer-Churn-Retention-Analysis
   ```
2. Run the SQL script against any PostgreSQL or MySQL client:
   ```bash
   psql -U your_user -d your_db -f customer_churn_analysis.sql
   ```
3. Or run the automated Python pipeline:
   ```bash
   python3 churn_analysis.py
   ```

---

**Author:** [Nakshatra Khanna](https://linkedin.com/in/nakshatra-khanna-a8322a407)  
*Junior Business Analyst | CGC Landran, Mohali*  
*Email:* nakshatrakhanna1@gmail.com | *Portfolio:* [nakshatrakhanna.netlify.app](https://nakshatrakhanna.netlify.app)
