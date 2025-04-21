DROP SCHEMA IF EXISTS Walmart;

CREATE SCHEMA Walmart;

USE Walmart;

-- Disable foreign key checks to avoid issues during table creation
SET
  foreign_key_checks = 0;

-- Schema definition for Walmart-like retail database (with ON DELETE CASCADE where appropriate)
START TRANSACTION;

CREATE TABLE
  Address (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    address_line_1 VARCHAR(255),
    address_line_2 VARCHAR(255),
    street_name VARCHAR(255),
    city_name VARCHAR(255),
    state_name VARCHAR(255),
    zipcode VARCHAR(255)
  );

CREATE TABLE
  Store (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(255),
    manager_name VARCHAR(255),
    phone_number VARCHAR(255),
    hours VARCHAR(255)
  );

CREATE TABLE
  Customer (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    contact_number VARCHAR(255),
    address_id INT,
    is_registered BOOLEAN,
    store_id INT,
    FOREIGN KEY (store_id) REFERENCES Store (store_id),
    FOREIGN KEY (address_id) REFERENCES Address (address_id)
  );

CREATE TABLE
  CustomerCard (
    card_hash VARCHAR(255) PRIMARY KEY,
    customer_id INT,
    addition_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customer (customer_id) ON DELETE CASCADE
  );

CREATE TABLE
  Payment (
    payment_id INT PRIMARY KEY,
    payment_method VARCHAR(255),
    amount DECIMAL(10, 2),
    payment_date TIMESTAMP,
    card_hash VARCHAR(255),
    approval_code VARCHAR(255),
    is_split_payment BOOLEAN,
    FOREIGN KEY (card_hash) REFERENCES CustomerCard (card_hash)
  );

CREATE TABLE
  Transaction_Header (
    transaction_id INT PRIMARY KEY,
    store_id INT NOT NULL,
    terminal_id INT,
    datetime TIMESTAMP,
    employee_id INT,
    customer_id INT,
    card_hash VARCHAR(255),
    payment_id INT,
    payment_type VARCHAR(255),
    total_amount DECIMAL(10, 2),
    tax_amount DECIMAL(10, 2),
    loyalty_points_earned INT,
    FOREIGN KEY (store_id) REFERENCES Store (store_id),
    FOREIGN KEY (customer_id) REFERENCES Customer (customer_id),
    FOREIGN KEY (card_hash) REFERENCES CustomerCard (card_hash),
    FOREIGN KEY (payment_id) REFERENCES Payment (payment_id)
  );

CREATE TABLE
  Tax_Category (
    tax_category_id INT PRIMARY KEY,
    name VARCHAR(255),
    description TEXT,
    is_food_eligible BOOLEAN
  );

CREATE TABLE
  State_Tax_Rate (
    state_code CHAR(2),
    tax_category_id INT,
    rate DECIMAL(5, 4),
    effective_date DATE,
    is_active BOOLEAN,
    PRIMARY KEY (state_code, tax_category_id),
    FOREIGN KEY (tax_category_id) REFERENCES Tax_Category (tax_category_id)
  );

CREATE TABLE
  Transaction_Tax_Detail (
    tax_detail_id INT PRIMARY KEY,
    transaction_id INT,
    tax_category_id INT,
    taxable_amount DECIMAL(10, 2),
    calculated_tax DECIMAL(10, 2),
    FOREIGN KEY (transaction_id) REFERENCES Transaction_Header (transaction_id),
    FOREIGN KEY (tax_category_id) REFERENCES Tax_Category (tax_category_id)
  );

CREATE TABLE
  Brand (
    brand_id INT PRIMARY KEY,
    brand_name VARCHAR(255),
    brand_category VARCHAR(255)
  );

CREATE TABLE
  Product (
    upc INT PRIMARY KEY,
    item_name VARCHAR(255),
    size VARCHAR(255),
    weight INT,
    storage_instructions VARCHAR(255),
    brand_id INT,
    tax_category_id INT,
    FOREIGN KEY (brand_id) REFERENCES Brand (brand_id),
    FOREIGN KEY (tax_category_id) REFERENCES Tax_Category (tax_category_id)
  );

CREATE TABLE
  Transaction_Line_Item (
    line_id INT PRIMARY KEY,
    transaction_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10, 2),
    discount_amount DECIMAL(10, 2),
    line_total DECIMAL(10, 2),
    FOREIGN KEY (transaction_id) REFERENCES Transaction_Header (transaction_id),
    FOREIGN KEY (product_id) REFERENCES Product (upc)
  );

CREATE TABLE
  Online_Orders (
    order_id INT PRIMARY KEY,
    web_id VARCHAR(255),
    customer_id INT,
    order_date TIMESTAMP,
    status VARCHAR(255),
    shipping_method VARCHAR(255),
    tracking_number VARCHAR(255),
    estimated_delivery DATE,
    actual_delivery DATE,
    FOREIGN KEY (customer_id) REFERENCES Customer (customer_id)
  );

CREATE TABLE
  Order_Line_Item (
    line_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10, 2),
    shipping_cost DECIMAL(10, 2),
    discount_code VARCHAR(255),
    FOREIGN KEY (order_id) REFERENCES Online_Orders (order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product (upc)
  );

CREATE TABLE
  Shipping (
    shipping_id INT PRIMARY KEY,
    order_id INT,
    carrier VARCHAR(255),
    service_level VARCHAR(255),
    tracking_number VARCHAR(255),
    ship_date DATE,
    delivery_status VARCHAR(255),
    FOREIGN KEY (order_id) REFERENCES Online_Orders (order_id) ON DELETE CASCADE
  );

-- Vendor order system
CREATE TABLE
  Vendor (
    vendor_id INT PRIMARY KEY,
    contact_person VARCHAR(255),
    email VARCHAR(255),
    contact_number VARCHAR(255),
    address_id INT,
    status VARCHAR(255),
    FOREIGN KEY (address_id) REFERENCES Address (address_id)
  );

CREATE TABLE
  Vendor_Order (
    order_id INT PRIMARY KEY,
    vendor_id INT,
    store_id INT,
    invoice_id INT,
    order_date DATE,
    fulfilled BOOLEAN,
    FOREIGN KEY (vendor_id) REFERENCES Vendor (vendor_id),
    FOREIGN KEY (store_id) REFERENCES Store (store_id)
  );

CREATE TABLE
  Order_Line (
    order_line_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    unit_cost DECIMAL(10, 2),
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Vendor_Order (order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product (upc)
  );

-- Invoice & receipt system
CREATE TABLE
  Invoice (
    invoice_id INT PRIMARY KEY,
    transaction_id INT UNIQUE,
    invoice_number VARCHAR(255),
    issue_date DATE,
    due_date DATE,
    payment_status VARCHAR(255),
    total_amount DECIMAL(10, 2),
    vendor_id INT,
    FOREIGN KEY (transaction_id) REFERENCES Transaction_Header (transaction_id),
    FOREIGN KEY (vendor_id) REFERENCES Vendor (vendor_id)
  );

CREATE TABLE
  Invoice_Line_Item (
    invoice_line_id INT PRIMARY KEY,
    invoice_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10, 2),
    tax_applied DECIMAL(10, 2),
    FOREIGN KEY (invoice_id) REFERENCES Invoice (invoice_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product (upc)
  );

CREATE TABLE
  Receipt (
    receipt_id INT PRIMARY KEY,
    transaction_id INT UNIQUE,
    receipt_type VARCHAR(255),
    delivery_method VARCHAR(255),
    timestamp TIMESTAMP,
    FOREIGN KEY (transaction_id) REFERENCES Transaction_Header (transaction_id)
  );

CREATE TABLE
  Loyalty_Account (
    account_id INT PRIMARY KEY,
    customer_id INT,
    tier_level VARCHAR(255),
    total_points INT,
    signup_date DATE,
    anniversary_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customer (customer_id)
  );

CREATE TABLE
  Reward (
    reward_id INT PRIMARY KEY,
    name VARCHAR(255),
    point_cost INT,
    start_date DATE,
    end_date DATE,
    description TEXT
  );

CREATE TABLE
  Redemption (
    redemption_id INT PRIMARY KEY,
    account_id INT,
    reward_id INT,
    redemption_date DATE,
    points_used INT,
    FOREIGN KEY (account_id) REFERENCES Loyalty_Account (account_id) ON DELETE CASCADE,
    FOREIGN KEY (reward_id) REFERENCES Reward (reward_id)
  );

CREATE TABLE
  Points_Transaction (
    points_id INT PRIMARY KEY,
    account_id INT NOT NULL,
    transaction_id INT,
    points_earned INT,
    points_redeemed INT,
    balance_after INT,
    transaction_date TIMESTAMP,
    FOREIGN KEY (account_id) REFERENCES Loyalty_Account (account_id) ON DELETE CASCADE,
    FOREIGN KEY (transaction_id) REFERENCES Transaction_Header (transaction_id)
  );

CREATE TABLE
  Tax_Exemption (
    exemption_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    exemption_code VARCHAR(255),
    valid_until DATE,
    issuing_state CHAR(2),
    FOREIGN KEY (customer_id) REFERENCES Customer (customer_id)
  );

CREATE TABLE
  Clothing_Product (
    upc INT PRIMARY KEY,
    clothing_type VARCHAR(255),
    gender VARCHAR(255),
    color VARCHAR(255),
    material VARCHAR(255),
    clothing_size VARCHAR(255),
    FOREIGN KEY (upc) REFERENCES Product (upc) ON DELETE CASCADE
  );

CREATE TABLE
  Cleaning_Product (
    upc INT PRIMARY KEY,
    tool_type VARCHAR(255),
    use_location VARCHAR(255),
    hazard_label VARCHAR(255),
    FOREIGN KEY (upc) REFERENCES Product (upc) ON DELETE CASCADE
  );

CREATE TABLE
  Health_Product (
    upc INT PRIMARY KEY,
    health_product_type VARCHAR(255),
    use_directions VARCHAR(255),
    product_ingredients VARCHAR(255),
    FOREIGN KEY (upc) REFERENCES Product (upc) ON DELETE CASCADE
  );

CREATE TABLE
  Home_Product (
    upc INT PRIMARY KEY,
    home_category VARCHAR(255),
    FOREIGN KEY (upc) REFERENCES Product (upc) ON DELETE CASCADE
  );

CREATE TABLE
  Electronic_Product (
    upc INT PRIMARY KEY,
    power_source VARCHAR(50),
    electronic_type VARCHAR(50),
    screen_size VARCHAR(50),
    FOREIGN KEY (upc) REFERENCES Product (upc) ON DELETE CASCADE
  );

CREATE TABLE
  Grocery_Product (
    upc INT PRIMARY KEY,
    grocery_type VARCHAR(255),
    expiration DATE,
    food_ingredients VARCHAR(255),
    FOREIGN KEY (upc) REFERENCES Product (upc) ON DELETE CASCADE
  );

CREATE TABLE
  Physical_Store (
    store_id INT PRIMARY KEY,
    address_id INT,
    FOREIGN KEY (store_id) REFERENCES Store (store_id) ON DELETE CASCADE,
    FOREIGN KEY (address_id) REFERENCES Address (address_id)
  );

CREATE TABLE
  Online_Store (
    store_id INT PRIMARY KEY,
    FOREIGN KEY (store_id) REFERENCES Store (store_id)
  );

CREATE TABLE
  Carries (
    store_id INT,
    upc INT,
    price FLOAT,
    quantity INT,
    min_quantity INT,
    max_quantity INT,
    PRIMARY KEY (store_id, upc),
    FOREIGN KEY (store_id) REFERENCES Store (store_id) ON DELETE CASCADE,
    FOREIGN KEY (upc) REFERENCES Product (upc) ON DELETE CASCADE
  );

COMMIT;

SET
  foreign_key_checks = 1;