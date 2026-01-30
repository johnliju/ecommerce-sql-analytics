import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random

# Set seed for reproducibility
np.random.seed(42)
random.seed(42)

# Constants
NUM_CUSTOMERS = 500
NUM_PRODUCTS = 50
NUM_ORDERS = 2000
START_DATE = datetime(2024, 1, 1)
END_DATE = datetime(2025, 12, 31)

# 1. Generate Customers
countries = ['USA', 'UK', 'Canada', 'Germany', 'France', 'Australia']
customers = []
for i in range(1, NUM_CUSTOMERS + 1):
    signup_date = START_DATE + timedelta(days=random.randint(0, 365))
    customers.append({
        'customer_id': i,
        'first_name': f'User_{i}',
        'last_name': f'Last_{i}',
        'email': f'user{i}@example.com',
        'signup_date': signup_date.strftime('%Y-%m-%d'),
        'country': random.choice(countries)
    })
df_customers = pd.DataFrame(customers)

# 2. Generate Products
categories = ['Electronics', 'Clothing', 'Home & Kitchen', 'Books', 'Beauty']
products = []
for i in range(1, NUM_PRODUCTS + 1):
    products.append({
        'product_id': i,
        'product_name': f'Product_{i}',
        'category': random.choice(categories),
        'price': round(random.uniform(10, 500), 2),
        'stock_quantity': random.randint(10, 1000)
    })
df_products = pd.DataFrame(products)

# 3. Generate Orders
orders = []
order_items = []
order_item_id_counter = 1

for i in range(1, NUM_ORDERS + 1):
    customer_id = random.randint(1, NUM_CUSTOMERS)
    signup_date = datetime.strptime(df_customers.loc[customer_id-1, 'signup_date'], '%Y-%m-%d')
    days_since_signup = (END_DATE - signup_date).days
    order_date = signup_date + timedelta(days=random.randint(0, max(0, days_since_signup)))
    
    status = random.choices(['Completed', 'Cancelled', 'Returned'], weights=[0.85, 0.1, 0.05])[0]
    
    orders.append({
        'order_id': i,
        'customer_id': customer_id,
        'order_date': order_date.strftime('%Y-%m-%d %H:%M:%S'),
        'status': status
    })
    
    num_items = random.randint(1, 5)
    total_amount = 0
    for _ in range(num_items):
        product = random.choice(products)
        quantity = random.randint(1, 3)
        unit_price = product['price']
        total_amount += quantity * unit_price
        
        order_items.append({
            'order_item_id': order_item_id_counter,
            'order_id': i,
            'product_id': product['product_id'],
            'quantity': quantity,
            'unit_price': unit_price
        })
        order_item_id_counter += 1
    
    orders[-1]['total_amount'] = round(total_amount, 2)

df_orders = pd.DataFrame(orders)
df_order_items = pd.DataFrame(order_items)

# 4. Generate Reviews
reviews = []
for i in range(1, 1000):
    order_item = random.choice(order_items)
    order = df_orders.iloc[order_item['order_id']-1]
    order_date = datetime.strptime(order['order_date'], '%Y-%m-%d %H:%M:%S')
    review_date = order_date + timedelta(days=random.randint(1, 30))
    
    reviews.append({
        'review_id': i,
        'product_id': order_item['product_id'],
        'customer_id': order['customer_id'],
        'rating': random.randint(1, 5),
        'review_date': review_date.strftime('%Y-%m-%d')
    })
df_reviews = pd.DataFrame(reviews)

# Save to CSV
df_customers.to_csv('customers.csv', index=False)
df_products.to_csv('products.csv', index=False)
df_orders.to_csv('orders.csv', index=False)
df_order_items.to_csv('order_items.csv', index=False)
df_reviews.to_csv('reviews.csv', index=False)

print("Data generation complete. CSV files saved.")
