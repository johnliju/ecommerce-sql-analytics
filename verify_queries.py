import sqlite3
import pandas as pd
import re

def run_query(conn, query_name, sql):
    print(f"\n--- Running Query: {query_name} ---")
    try:
        df = pd.read_sql_query(sql, conn)
        print(df.head(10))
        return df
    except Exception as e:
        print(f"Error running {query_name}: {e}")
        return None

# Connect to the database
conn = sqlite3.connect('ecommerce.db')

# Read the queries file
with open('analytics_queries.sql', 'r') as f:
    content = f.read()

# Split by numbered comments like "-- 1. ", "-- 2. ", etc.
# This regex matches "-- 1. Name" and captures the name
query_blocks = re.split(r'-- \d+\. ', content)

query_names = [
    "Monthly Revenue Growth Rate",
    "Customer Lifetime Value (CLV) Analysis",
    "Cohort Analysis (Retention Rate)",
    "RFM Segmentation",
    "Product Affinity Analysis",
    "Churn Prediction"
]

# The first block is the header, skip it
for i, block in enumerate(query_blocks[1:]):
    lines = block.strip().split('\n')
    name = lines[0] # The first line after the split is the title
    sql_lines = lines[1:] # The rest is the SQL
    
    sql = '\n'.join(sql_lines)
    # Clean up SQL: remove all comments
    sql_clean = re.sub(r'--.*', '', sql).strip()
    
    if sql_clean:
        run_query(conn, name, sql_clean)

conn.close()
