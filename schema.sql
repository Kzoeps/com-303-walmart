SET foreign_key_checks = 0;
-- Schema definition for Walmart-like retail database (with ON DELETE CASCADE for child tables)
START TRANSACTION;
Create table address ( 
	address_id varchar(255) primary key, 
	address_line_1 varchar(255), 
	address_line_2 varchar(255), 
  street_name varchar (255), 
  City_name varchar (255), 
  State_name varchar (255), 
  Zipcode varchar(255), 

);
create table Store(
  store_id int primary key,
  store_name varchar(255),
  manager_name varchar(255),
  phone_number varchar(255),
  hours varchar(255)
);

create table customer (
    customer_id int primary key,
    first_name varchar(255),
    last_name varchar(255),
    contact_number varchar(255),
    address_id varchar(255),
    is_registered boolean,
    store_id int,
    foreign key (store_id) references Store(store_id)
    Foreign key(address_id) references Address(address_id)
);

create table customercard (
    card_hash varchar(255) primary key,
    customer_id int,
    addition_date date,
    foreign key (customer_id) references customer(customer_id)
);

create table payment (
    payment_id int primary key,
    payment_method varchar(255),
    amount decimal(10,2),
    payment_date timestamp,
    card_hash varchar(255),
    approval_code varchar(255),
    is_split_payment boolean,
    foreign key (card_hash) references customercard(card_hash)
);

create table transaction_header (
    transaction_id int primary key,
    store_id int not null,
    terminal_id int,
    datetime timestamp,
    employee_id int,
    customer_id int,
    card_hash varchar(255),
    payment_id int,
    payment_type varchar(255),
    total_amount decimal(10,2),
    tax_amount decimal(10,2),
    loyalty_points_earned int,
    foreign key (store_id) references store(store_id),
    foreign key (customer_id) references customer(customer_id),
    foreign key (card_hash) references customercard(card_hash),
    foreign key (payment_id) references payment(payment_id)
);

create table tax_category (
    tax_category_id int primary key,
    name varchar(255),
    description text,
    is_food_eligible boolean
);

create table state_tax_rate (
    state_code char(2),
    tax_category_id int,
    rate decimal(5,4),
    effective_date date,
    is_active boolean,
    primary key (state_code, tax_category_id),
    foreign key (tax_category_id) references tax_category(tax_category_id)
);

create table transaction_tax_detail (
    tax_detail_id int primary key,
    transaction_id int,
    tax_category_id int,
    taxable_amount decimal(10,2),
    calculated_tax decimal(10,2),
    foreign key (transaction_id) references transaction_header(transaction_id),
    foreign key (tax_category_id) references tax_category(tax_category_id)
);

create table Brand(
  brand_id int primary key,
  brand_name varchar(255),
  brand_category varchar(255)
);

create table Product (
  UPC int primary key,
  item_name varchar(255),
  size varchar(255),
  weight int,
  storage_instructions varchar(255),
  brand_id int,
  tax_category_id int,
  foreign key (brand_id) references Brand,
  foreign key (tax_category_id) references tax_category
);

create table transaction_line_item (
    line_id int primary key,
    transaction_id int,
    product_id int,
    quantity int,
    unit_price decimal(10,2),
    discount_amount decimal(10,2),
    line_total decimal(10,2),
    foreign key (transaction_id) references transaction_header(transaction_id),
    foreign key (product_id) references Product(UPC)
);



create table online_orders (
    order_id int primary key,
    web_id varchar(255),
    customer_id int,
    order_date timestamp,
    status varchar(255),
    shipping_method varchar(255),
    tracking_number varchar(255),
    estimated_delivery date,
    actual_delivery date,
    foreign key (customer_id) references customer(customer_id)
);

create table order_line_item (
    line_id int primary key,
    order_id int,
    product_id int,
    quantity int,
    unit_price decimal(10,2),
    shipping_cost decimal(10,2),
    discount_code varchar(255),
    foreign key (order_id) references online_orders(order_id),
    foreign key (product_id) references product(upc)
);

create table shipping (
    shipping_id int primary key,
    order_id int,
    carrier varchar(255),
    service_level varchar(255),
    tracking_number varchar(255),
    ship_date date,
    delivery_status varchar(255),
    foreign key (order_id) references online_orders(order_id)
);

-- vendor order system

CREATE TABLE vendor (
	vendor_id int PRIMARY KEY,
	contact_person varchar(255),
	email varchar(255),
	contact_number varchar(255),
            Address_id varchar(255),
	status varchar(255),
            Foreign key (address_id) references Address(address_id)
);

create table vendor_order (
    order_id int primary key,
    vendor_id int,
    store_id int,
    invoice_id int,
    order_date date,
    fulfilled boolean,
    foreign key (vendor_id) references vendor(vendor_id),
    foreign key (store_id) references store(store_id)
);

create table orderline (
    order_line_id int primary key,
    order_id int,
    product_id int,
    unit_cost decimal(10,2),
    quantity int,
    foreign key (order_id) references vendororder(order_id),
    foreign key (product_id) references product(upc)
);

-- invoice & receipt system

create table invoice (
    invoice_id int primary key,
    transaction_id int unique,
    invoice_number varchar(255),
    issue_date date,
    due_date date,
    payment_status varchar(255),
    total_amount decimal(10,2),
    vendor_id int,
    foreign key (transaction_id) references transaction_header(transaction_id),
    foreign key (vendor_id) references vendor(vendor_id)
);

create table invoice_line_item (
    invoice_line_id int primary key,
    invoice_id int,
    product_id int,
    quantity int,
    unit_price decimal(10,2),
    tax_applied decimal(10,2),
    foreign key (invoice_id) references invoice(invoice_id),
    foreign key (product_id) references product(upc)
);

create table receipt (
    receipt_id int primary key,
    transaction_id int unique,
    receipt_type varchar(255),
    delivery_method varchar(255),
    timestamp timestamp,
    foreign key (transaction_id) references transaction_header(transaction_id)
);


create table loyalty_account (
    account_id int primary key,
    customer_id int,
    tier_level varchar(255),
    total_points int,
    signup_date date,
    anniversary_date date,
    foreign key (customer_id) references customer(customer_id)
);

create table reward (
    reward_id int primary key,
    name varchar(255),
    point_cost int,
    start_date date,
    end_date date,
    description text
);

create table redemption (
    redemption_id int primary key,
    account_id int,
    reward_id int,
    redemption_date date,
    points_used int,
    foreign key (account_id) references loyalty_account(account_id),
    foreign key (reward_id) references reward(reward_id)
);

create table points_transaction (
    points_id int primary key,
    account_id int not null,
    transaction_id int,
    points_earned int,
    points_redeemed int,
    balance_after int,
    transaction_date timestamp,
    foreign key (account_id) references loyalty_account(account_id),
    foreign key (transaction_id) references transaction_header(transaction_id)
);

create table tax_exemption (
    exemption_id int primary key,
    customer_id int not null,
    exemption_code varchar(255),
    valid_until date,
    issuing_state char(2),
    foreign key (customer_id) references customer(customer_id)
);


create table Clothing_Product(
  UPC int primary key,
  clothing_type varchar(255),
  gender varchar(255),
  color varchar(255),
  material varchar(255),
  clothing_size varchar(255),
  foreign key (UPC) references Product
);

create table Cleaning_Product(
  UPC int primary key,
  tool_type varchar(255),
  use_location varchar(255),
  hazard_label varchar(255),
  foreign key (UPC) references Product
);

create table Health_Product(
  UPC int primary key,
  health_product_type varchar(255),
  use_directions varchar(255),
  product_ingredients varchar(255),
  foreign key (UPC) references Product
);

create table Home_Product(
  UPC int primary key,
  home_category  varchar(255),
  foreign key (UPC) references Product
);

create table Electronic_Product(
  UPC int primary key,
  power_source  varchar(50),
  electronic_type  varchar(50),
  screen_size  varchar(50),
  foreign key (UPC) references Product
);

create table Grocery_Product(
  UPC int primary key,
  grocery_type  varchar(255),
  expiration date,
  food_ingredients  varchar(255),
  foreign key (UPC) references Product
);

create table Physical_Store(
  store_id int primary key,
  address_id varchar(255),
  foreign key (store_id) references Store,
  Foreign key (address_id) references Address(address_id)
);

create table Online_Store(
  store_id int primary key,
  foreign key (store_id) references Store
);

create table carries(
  store_id int,
  UPC int,
  price float,
  quantity int,
  min_quantity int,
  max_quantity int,
  foreign key (store_id) references Store,
  foreign key (UPC) references Product,
  primary key (store_id, UPC)
);

COMMIT;
SET foreign_key_checks = 1;