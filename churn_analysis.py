"""
E-Commerce Customer Retention & Churn Analytics Pipeline
Author: Nakshatra Khanna (Junior Business Analyst)
Description: Python data processing script computing RFM scoring, cohort metrics, and churn distribution.
"""

import pandas as pd
import numpy as np

def run_analytics(csv_file="sample_ecommerce_data.csv"):
    df = pd.read_csv(csv_file)
    print("=" * 60)
    print("E-COMMERCE BUSINESS ANALYTICS & CHURN SUMMARY REPORT")
    print("=" * 60)
    
    total_rev = df['OrderValue_INR'].sum()
    total_cust = df['CustomerID'].nunique()
    total_orders = len(df)
    aov = df['OrderValue_INR'].mean()
    
    print(f"Total Gross Revenue:     ₹{total_rev:,.2f}")
    print(f"Total Unique Customers:  {total_cust:,}")
    print(f"Total Order Volume:      {total_orders:,}")
    print(f"Average Order Value:     ₹{aov:,.2f}")
    print("-" * 60)
    
    # Category Analysis
    cat_summary = df.groupby('ProductCategory').agg(
        Revenue=('OrderValue_INR', 'sum'),
        Orders=('InvoiceID', 'count'),
        Avg_Discount=('Discount_Pct', 'mean'),
        Churn_Rate=('ReturnCustomerFlag', lambda x: 100 * (1 - x.mean()))
    ).reset_index()
    
    print("\nPERFORMANCE BY PRODUCT CATEGORY:")
    print(cat_summary.to_string(index=False))
    
    # RFM Segment Aggregation
    rfm = df.groupby('CustomerID').agg({
        'DaysSinceLastPurchase': 'min',
        'InvoiceID': 'count',
        'OrderValue_INR': 'sum'
    }).rename(columns={
        'DaysSinceLastPurchase': 'Recency',
        'InvoiceID': 'Frequency',
        'OrderValue_INR': 'Monetary'
    })
    
    rfm['R_Score'] = pd.qcut(rfm['Recency'], 4, labels=[4, 3, 2, 1])
    rfm['F_Score'] = pd.qcut(rfm['Frequency'].rank(method='first'), 4, labels=[1, 2, 3, 4])
    rfm['M_Score'] = pd.qcut(rfm['Monetary'], 4, labels=[1, 2, 3, 4])
    
    def segment_cust(row):
        r, f = int(row['R_Score']), int(row['F_Score'])
        if r >= 3 and f >= 3:
            return 'Champions (High Loyalty)'
        elif r >= 3 and f < 3:
            return 'Promising (New Shoppers)'
        elif r <= 2 and f >= 3:
            return 'At Risk (High Value / Inactive)'
        else:
            return 'Hibernating / Churned'
            
    rfm['Segment'] = rfm.apply(segment_cust, axis=1)
    
    print("\nCUSTOMER RFM SEGMENT BREAKDOWN:")
    seg_counts = rfm['Segment'].value_counts(normalize=True) * 100
    for seg, pct in seg_counts.items():
        print(f"• {seg:<32}: {pct:5.1f}% of customer base")
    
    print("\n[✓] Analytics pipeline executed successfully.")

if __name__ == '__main__':
    run_analytics()
