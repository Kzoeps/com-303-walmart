-- Complete seed data for Walmart schema
-- 1. Addresses
INSERT IGNORE INTO Address (
  address_id,
  address_line_1,
  address_line_2,
  street_name,
  city_name,
  state_name,
  zipcode
)
VALUES
  (
    1,
    '123 Main St',
    NULL,
    'Main St',
    'Anytown',
    'NY',
    '12345'
  ),
  (
    2,
    '456 Oak Ave',
    'Suite 5',
    'Oak Ave',
    'Othertown',
    'NY',
    '12346'
  ),
  (
    3,
    '789 Pine Rd',
    NULL,
    'Pine Rd',
    'Bigcity',
    'CA',
    '90001'
  ),
  (
    4,
    '101 Industrial Way',
    NULL,
    'Industrial Way',
    'Townsville',
    'TX',
    '75001'
  ),
  (
    5,
    '202 Warehouse Rd',
    'Building 3',
    'Warehouse Rd',
    'Village',
    'FL',
    '32004'
  );

-- 2. Store
INSERT IGNORE INTO Store (
  store_id,
  store_name,
  manager_name,
  phone_number,
  hours
)
VALUES
  (
    1,
    'Main Street Store',
    'Alice Johnson',
    '555-123-4567',
    'Mon–Sun 9am–9pm'
  );

-- 3. Physical_Store link
INSERT IGNORE INTO Physical_Store (store_id, address_id)
VALUES
  (1, 1);

-- 4. Tax categories
INSERT IGNORE INTO Tax_Category (
  tax_category_id,
  name,
  description,
  is_food_eligible
)
VALUES
  (1, 'General', 'Standard retail tax', FALSE),
  (
    2,
    'Food',
    'Reduced tax rate for food items',
    TRUE
  );

-- 5. State tax rates
INSERT IGNORE INTO State_Tax_Rate (
  state_code,
  tax_category_id,
  rate,
  effective_date,
  is_active
)
VALUES
  ('NY', 1, 0.0825, '2025-01-01', TRUE),
  ('NY', 2, 0.0400, '2025-01-01', TRUE);

-- 6. Brands
INSERT IGNORE INTO Brand (brand_id, brand_name, brand_category) VALUES
  (1 , 'Apple',                'Electronics'),
  (2 , 'Samsung',              'Electronics'),
  (3 , 'Sony',                 'Electronics'),
  (4 , 'Coca-Cola',            'Beverage'),
  (5 , 'Nestlé',               'Food'),
  (6 , 'Nike',                 'Clothing'),
  (7 , 'Adidas',               'Clothing'),
  (8 , 'Procter & Gamble',     'Cleaning'),
  (9 , 'Kellogg''s',           'Food'),
  (10, 'Levi''s',              'Clothing');

-- 7. Products
INSERT IGNORE INTO Product (
  upc,
  item_name,
  size,
  weight,
  storage_instructions,
  brand_id,
  tax_category_id
)
VALUES
  (1000001, 'USB Cable', '1m', 50, 'Keep dry', 1, 1),
  (
    2000001,
    'Organic Apple',
    '1 lb',
    454,
    'Refrigerate',
    2,
    2
  ),
  (
    3000001,
    'Basic T-Shirt',
    'M',
    200,
    'Machine wash cold',
    3,
    1
  );

-- 8. Inventory levels (Carries)
INSERT IGNORE INTO Carries (
  store_id,
  upc,
  price,
  quantity,
  min_quantity,
  max_quantity
)
VALUES
  (1, 1000001, 9.99, 100, 10, 200),
  (1, 2000001, 0.99, 200, 50, 500),
  (1, 3000001, 14.99, 50, 10, 100);

-- 9. Customer
INSERT IGNORE INTO Customer (
  customer_id,
  first_name,
  last_name,
  contact_number,
  address_id,
  is_registered,
  store_id
)
VALUES
  (1, 'Bob', 'Smith', '555-000-0000', 2, TRUE, 1);

-- 10. CustomerCard
INSERT IGNORE INTO CustomerCard (card_hash, customer_id, addition_date)
VALUES
  ('0423-VISA-354', 1, '2025-04-01');

-- 11. Vendors
INSERT IGNORE INTO Vendor (
  vendor_id,
  contact_person,
  email,
  contact_number,
  address_id,
  status
)
VALUES
  (
    1,
    'John Doe',
    'john@acmedist.com',
    '555-900-0001',
    3,
    'Active'
  ),
  (
    2,
    'Mary Lee',
    'mary@freshfarms.co',
    '555-900-0002',
    4,
    'Active'
  ),
  (
    3,
    'Carlos Ruiz',
    'carlos@stylewear.biz',
    '555-900-0003',
    5,
    'Active'
  );

-- 12. Vendor ↔ Product mappings
INSERT IGNORE INTO Vendor_Product (vendor_id, product_id, quoted_cost)
VALUES
  (1, 1000001, 5),
  (2, 2000001, 8),
  (3, 3000001, 20);

-- artificial scarcity to test vendor order. Remove once done
UPDATE Carries
SET
  quantity = 9
WHERE
  store_id = 1
  and upc = 1000001;