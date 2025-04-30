/* =======================================================================
WALMART DEMO – SEED DATA
-----------------------------------------------------------------------
Load after the DDL.  The database is assumed to be empty.
==================================================================== */
SET
    FOREIGN_KEY_CHECKS = 0;

/*-----------------------------------------------------------------------
1. ADDRESSES  (30 rows)
---------------------------------------------------------------------*/
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
        'Albany',
        'NY',
        '12207'
    ),
    (
        2,
        '456 Oak Ave',
        'Suite 5',
        'Oak Ave',
        'Rochester',
        'NY',
        '14604'
    ),
    (
        3,
        '789 Pine Rd',
        NULL,
        'Pine Rd',
        'San Jose',
        'CA',
        '95112'
    ),
    (
        4,
        '101 Industrial Way',
        NULL,
        'Industrial Way',
        'Dallas',
        'TX',
        '75201'
    ),
    (
        5,
        '202 Warehouse Rd',
        'Bld 3',
        'Warehouse Rd',
        'Miami',
        'FL',
        '33101'
    ),
    (
        6,
        '303 Market St',
        NULL,
        'Market St',
        'Chicago',
        'IL',
        '60602'
    ),
    (
        7,
        '404 River Blvd',
        NULL,
        'River Blvd',
        'Seattle',
        'WA',
        '98104'
    ),
    (
        8,
        '505 Sunset Dr',
        NULL,
        'Sunset Dr',
        'Phoenix',
        'AZ',
        '85004'
    ),
    (
        9,
        '606 Cedar Ln',
        NULL,
        'Cedar Ln',
        'Atlanta',
        'GA',
        '30303'
    ),
    (
        10,
        '707 Broadway',
        NULL,
        'Broadway',
        'Cleveland',
        'OH',
        '44115'
    ),
    /* vendor / misc. */
    (
        11,
        '11 Tech Park',
        NULL,
        'Tech Park',
        'Austin',
        'TX',
        '78701'
    ),
    (
        12,
        '12 Innovation Pl',
        NULL,
        'Innovation Pl',
        'Palo Alto',
        'CA',
        '94301'
    ),
    (
        13,
        '13 Madison Ave',
        NULL,
        'Madison Ave',
        'New York',
        'NY',
        '10010'
    ),
    (
        14,
        '14 Harbor Way',
        NULL,
        'Harbor Way',
        'Boston',
        'MA',
        '02110'
    ),
    (
        15,
        '15 Commerce Ct',
        NULL,
        'Commerce Ct',
        'Denver',
        'CO',
        '80202'
    ),
    (
        16,
        '16 Green St',
        NULL,
        'Green St',
        'Portland',
        'OR',
        '97204'
    ),
    (
        17,
        '17 Maple Ave',
        NULL,
        'Maple Ave',
        'Charlotte',
        'NC',
        '28202'
    ),
    (
        18,
        '18 Pioneer Rd',
        NULL,
        'Pioneer Rd',
        'Salt Lake City',
        'UT',
        '84101'
    ),
    (
        19,
        '19 Gateway Blvd',
        NULL,
        'Gateway Blvd',
        'Las Vegas',
        'NV',
        '89101'
    ),
    (
        20,
        '20 Bay St',
        NULL,
        'Bay St',
        'Tampa',
        'FL',
        '33602'
    ),
    (
        21,
        '21 Lakeview Dr',
        NULL,
        'Lakeview Dr',
        'Madison',
        'WI',
        '53703'
    ),
    (
        22,
        '22 Redwood Hwy',
        NULL,
        'Redwood Hwy',
        'San Rafael',
        'CA',
        '94903'
    ),
    (
        23,
        '23 Liberty Ln',
        NULL,
        'Liberty Ln',
        'Philadelphia',
        'PA',
        '19106'
    ),
    (
        24,
        '24 Summit Ave',
        NULL,
        'Summit Ave',
        'Minneapolis',
        'MN',
        '55401'
    ),
    (
        25,
        '25 Horizon Dr',
        NULL,
        'Horizon Dr',
        'Boise',
        'ID',
        '83702'
    ),
    (
        26,
        '26 Coral St',
        NULL,
        'Coral St',
        'Honolulu',
        'HI',
        '96813'
    ),
    (
        27,
        '27 Skyway Rd',
        NULL,
        'Skyway Rd',
        'Detroit',
        'MI',
        '48226'
    ),
    (
        28,
        '28 Heritage Pkwy',
        NULL,
        'Heritage Pkwy',
        'Columbus',
        'OH',
        '43215'
    ),
    (
        29,
        '29 Victory Blvd',
        NULL,
        'Victory Blvd',
        'Richmond',
        'VA',
        '23219'
    ),
    (
        30,
        '30 Frontier St',
        NULL,
        'Frontier St',
        'Anchorage',
        'AK',
        '99501'
    );

/*-----------------------------------------------------------------------
2. STORES  (10 physical)  + PHYSICAL_STORE link
---------------------------------------------------------------------*/
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
        'Albany Supercenter',
        'Alice Johnson',
        '518-555-0101',
        'Mon–Sun 8-22'
    ),
    (
        2,
        'Rochester Supercenter',
        'Bob Lee',
        '585-555-0102',
        'Mon–Sun 8-22'
    ),
    (
        3,
        'San Jose Supercenter',
        'Carlos Ruiz',
        '408-555-0103',
        'Mon–Sun 8-22'
    ),
    (
        4,
        'Dallas Supercenter',
        'Dina Patel',
        '214-555-0104',
        'Mon–Sun 8-22'
    ),
    (
        5,
        'Miami Supercenter',
        'Ethan Wong',
        '305-555-0105',
        'Mon–Sun 8-22'
    ),
    (
        6,
        'Chicago Supercenter',
        'Fiona Kim',
        '312-555-0106',
        'Mon–Sun 8-22'
    ),
    (
        7,
        'Seattle Supercenter',
        'George Smith',
        '206-555-0107',
        'Mon–Sun 8-22'
    ),
    (
        8,
        'Phoenix Supercenter',
        'Hannah Lee',
        '602-555-0108',
        'Mon–Sun 8-22'
    ),
    (
        9,
        'Atlanta Supercenter',
        'Ivan Chen',
        '404-555-0109',
        'Mon–Sun 8-22'
    ),
    (
        10,
        'Cleveland Supercenter',
        'Julia Park',
        '216-555-0110',
        'Mon–Sun 8-22'
    );

INSERT IGNORE INTO Physical_Store (store_id, address_id)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (6, 6),
    (7, 7),
    (8, 8),
    (9, 9),
    (10, 10);

/*-----------------------------------------------------------------------
3.  ONLINE STORE  (Store_ID = 11)
---------------------------------------------------------------------*/
INSERT IGNORE INTO Store (
    store_id,
    store_name,
    manager_name,
    phone_number,
    hours
)
VALUES
    (
        11,
        'Walmart.com',
        'E-Com Ops',
        '800-925-6278',
        '24/7'
    );

INSERT IGNORE INTO Online_Store (store_id)
VALUES
    (11);

/*-----------------------------------------------------------------------
4. TAX CATEGORIES  +  STATE RATES
---------------------------------------------------------------------*/
INSERT IGNORE INTO Tax_Category (
    tax_category_id,
    name,
    description,
    is_food_eligible
)
VALUES
    (1, 'General', 'Standard retail tax', FALSE),
    (2, 'Food', 'Reduced rate for food & bev', TRUE),
    (3, 'Health', 'OTC health / personal care', FALSE);

INSERT IGNORE INTO State_Tax_Rate (
    state_code,
    tax_category_id,
    rate,
    effective_date,
    is_active
)
VALUES
    ('NY', 1, 0.0825, '2025-01-01', TRUE),
    ('NY', 2, 0.0400, '2025-01-01', TRUE),
    ('CA', 1, 0.0825, '2025-01-01', TRUE),
    ('CA', 2, 0.0300, '2025-01-01', TRUE),
    ('TX', 1, 0.0625, '2025-01-01', TRUE),
    ('TX', 2, 0.0000, '2025-01-01', TRUE),
    ('IL', 1, 0.0875, '2025-01-01', TRUE),
    ('IL', 2, 0.0100, '2025-01-01', TRUE);

/*-----------------------------------------------------------------------
5. BRANDS  (12)
---------------------------------------------------------------------*/
INSERT IGNORE INTO Brand (brand_id, brand_name, brand_category)
VALUES
    (1, 'Apple', 'Electronics'),
    (2, 'Samsung', 'Electronics'),
    (3, 'Sony', 'Electronics'),
    (4, 'Nike', 'Clothing'),
    (5, 'Adidas', 'Clothing'),
    (6, 'Coca-Cola', 'Beverage'),
    (7, 'Nestlé', 'Food'),
    (8, 'Kellogg''s', 'Food'),
    (9, 'Procter & Gamble', 'Home/Health'),
    (10, 'Levi''s', 'Clothing'),
    (11, 'Logitech', 'Electronics'),
    (12, 'HP', 'Electronics');

/*-----------------------------------------------------------------------
6. PRODUCTS  (25 SKUs)
---------------------------------------------------------------------*/
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
    (
        11111111,
        'iPhone 15 128 GB',
        '128GB',
        174,
        'Keep dry',
        1,
        1
    ),
    (
        12121212,
        'MacBook Pro 14" 512 GB',
        '14"',
        1400,
        'Keep dry',
        1,
        1
    ),
    (
        13131313,
        'AirPods Pro 2nd Gen',
        'One',
        50,
        'Keep dry',
        1,
        1
    ),
    (
        22222222,
        'Samsung 55" 4K Smart TV',
        '55"',
        15000,
        'Keep dry',
        2,
        1
    ),
    (
        23232323,
        'Galaxy Tab S9 256 GB',
        '11"',
        600,
        'Keep dry',
        2,
        1
    ),
    (
        33333333,
        'Sony WH-1000XM5 Headphones',
        'One',
        250,
        'Store in case',
        3,
        1
    ),
    (
        34343434,
        'PlayStation 5 Console',
        'One',
        45000,
        'Keep dry',
        3,
        1
    ),
    (
        44444444,
        'Nike Dri-FIT Running Shirt M',
        'M',
        200,
        'Machine wash cold',
        4,
        1
    ),
    (
        45454545,
        'Nike Air Zoom Pegasus 40 M9',
        'Pair',
        300,
        'Store in box',
        4,
        1
    ),
    (
        55555555,
        'Adidas Ultraboost 22 M9',
        'Pair',
        300,
        'Store in box',
        5,
        1
    ),
    (
        56565656,
        'Adidas Crew Socks 6-pk',
        '6-pk',
        180,
        'Machine wash warm',
        5,
        1
    ),
    (
        66666666,
        'Coke Original 12 oz 12-pk',
        '12×12oz',
        4080,
        'Refrigerate',
        6,
        2
    ),
    (
        67676767,
        'Coke Zero 12 oz 12-pk',
        '12×12oz',
        4080,
        'Refrigerate',
        6,
        2
    ),
    (
        77777777,
        'Nestlé Chocolate Chips 12 oz',
        '12oz',
        340,
        'Store dry',
        7,
        2
    ),
    (
        78787878,
        'Nestlé Pure Life Water 24-pk',
        '24-pk',
        11562,
        'Store dry',
        7,
        2
    ),
    (
        88888888,
        'Kellogg''s Corn Flakes 18 oz',
        '18oz',
        510,
        'Store dry',
        8,
        2
    ),
    (
        89898989,
        'Kellogg''s Frosted Flakes 19 oz',
        '19oz',
        539,
        'Store dry',
        8,
        2
    ),
    (
        99999999,
        'Tide Detergent 92 oz',
        '92oz',
        2608,
        'Keep away from kids',
        9,
        3
    ),
    (
        98989898,
        'Tide PODS Original 42 ct',
        '42 ct',
        960,
        'Keep away from kids',
        9,
        3
    ),
    (
        97979797,
        'Gillette Fusion5 Blades 8-ct',
        '8-ct',
        120,
        'Keep dry',
        9,
        3
    ),
    (
        10101010,
        'Levi''s 501 Jeans 33×32',
        '33×32',
        650,
        'Machine wash cold',
        10,
        1
    ),
    (
        12131415,
        'Levi''s Trucker Jacket L',
        'L',
        800,
        'Machine wash cold',
        10,
        1
    ),
    (
        11121314,
        'Logitech MX Master 3S Mouse',
        'One',
        141,
        'Keep dry',
        11,
        1
    ),
    (
        14151617,
        'HP Pavilion 15" Laptop',
        '15"',
        17000,
        'Keep dry',
        12,
        1
    ),
    (
        85858585,
        'Tide PODS Spring Meadow 57 ct',
        '57 ct',
        1300,
        'Keep away from kids',
        9,
        3
    );

/*-----------------------------------------------------------------------
7. VENDORS  (25 rows – one per product)
---------------------------------------------------------------------*/
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
        'Tim Cook',
        'iphone@apple.com',
        '408-900-0001',
        11,
        'Active'
    ),
    (
        2,
        'Lisa Perez',
        'mac@apple.com',
        '408-900-0002',
        11,
        'Active'
    ),
    (
        3,
        'Mark Chen',
        'pods@apple.com',
        '408-900-0003',
        11,
        'Active'
    ),
    (
        4,
        'Jane Kim',
        'tv@samsung.com',
        '212-900-0004',
        12,
        'Active'
    ),
    (
        5,
        'Aaron Yu',
        'tablet@samsung.com',
        '212-900-0005',
        12,
        'Active'
    ),
    (
        6,
        'Ken Tanaka',
        'audio@sony.com',
        '310-900-0006',
        13,
        'Active'
    ),
    (
        7,
        'Yuki Suzuki',
        'ps5@sony.com',
        '310-900-0007',
        13,
        'Active'
    ),
    (
        8,
        'Evelyn Green',
        'shirt@nike.com',
        '503-900-0008',
        16,
        'Active'
    ),
    (
        9,
        'Oliver Grant',
        'pegasus@nike.com',
        '503-900-0009',
        16,
        'Active'
    ),
    (
        10,
        'Sofia Weiss',
        'boost@adidas.com',
        '971-900-0010',
        16,
        'Active'
    ),
    (
        11,
        'Lucas Schmidt',
        'socks@adidas.com',
        '971-900-0011',
        16,
        'Active'
    ),
    (
        12,
        'Carlos Diaz',
        'cola@coca-cola.com',
        '404-900-0012',
        17,
        'Active'
    ),
    (
        13,
        'Maria Diaz',
        'zero@coca-cola.com',
        '404-900-0013',
        17,
        'Active'
    ),
    (
        14,
        'Anita Singh',
        'chips@nestle.com',
        '312-900-0014',
        6,
        'Active'
    ),
    (
        15,
        'Ravi Patel',
        'water@nestle.com',
        '312-900-0015',
        6,
        'Active'
    ),
    (
        16,
        'John Baker',
        'corn@kelloggs.com',
        '517-900-0016',
        18,
        'Active'
    ),
    (
        17,
        'Grace Hill',
        'frosted@kelloggs.com',
        '517-900-0017',
        18,
        'Active'
    ),
    (
        18,
        'Nathan Hall',
        'tide@pg.com',
        '513-900-0018',
        23,
        'Active'
    ),
    (
        19,
        'Emma Cruz',
        'pods@pg.com',
        '513-900-0019',
        23,
        'Active'
    ),
    (
        20,
        'Owen Reed',
        'gillette@pg.com',
        '513-900-0020',
        23,
        'Active'
    ),
    (
        21,
        'Chloe Lopez',
        'jeans@levis.com',
        '415-900-0021',
        22,
        'Active'
    ),
    (
        22,
        'Noah Sanchez',
        'jacket@levis.com',
        '415-900-0022',
        22,
        'Active'
    ),
    (
        23,
        'Ella Foster',
        'mouse@logitech.com',
        '510-900-0023',
        12,
        'Active'
    ),
    (
        24,
        'Mason Price',
        'laptop@hp.com',
        '650-900-0024',
        12,
        'Active'
    ),
    (
        25,
        'Spare Vendor',
        'extra@demo.com',
        '999-900-9999',
        24,
        'Inactive'
    );

/*-----------------------------------------------------------------------
8. VENDOR_PRODUCT  (1 : 1 mapping)
---------------------------------------------------------------------*/
INSERT IGNORE INTO Vendor_Product (vendor_id, product_id, quoted_cost)
VALUES
    (1, 11111111, 650.00),
    (2, 12121212, 1150.00),
    (3, 13131313, 180.00),
    (4, 22222222, 500.00),
    (5, 23232323, 400.00),
    (6, 33333333, 220.00),
    (7, 34343434, 420.00),
    (8, 44444444, 20.00),
    (9, 45454545, 70.00),
    (10, 55555555, 120.00),
    (11, 56565656, 18.00),
    (12, 66666666, 5.00),
    (13, 67676767, 5.00),
    (14, 77777777, 2.20),
    (14, 78787878, 3.20),
    (16, 88888888, 3.50),
    (17, 89898989, 3.70),
    (18, 99999999, 9.00),
    (19, 98989898, 14.00),
    (20, 97979797, 11.00),
    (21, 10101010, 45.00),
    (22, 12131415, 55.00),
    (23, 11121314, 70.00),
    (24, 14151617, 520.00),
    (25, 85858585, 16.00);

/*-----------------------------------------------------------------------
9. INVENTORY  –  Carries spread across 10 stores
---------------------------------------------------------------------*/
TRUNCATE TABLE Carries;

INSERT INTO
    Carries (
        store_id,
        upc,
        price,
        quantity,
        min_quantity,
        max_quantity
    )
VALUES
    /* Store 1 – Albany */
    (1, 11111111, 799.99, 2, 3, 30),
    (1, 44444444, 34.99, 40, 10, 80),
    (1, 66666666, 7.99, 60, 15, 150),
    (1, 99999999, 12.99, 25, 5, 60),
    (1, 88888888, 5.49, 50, 10, 120),
    /* Store 2 – Rochester */
    (2, 23232323, 799.99, 12, 3, 25),
    (2, 34343434, 499.99, 8, 2, 20),
    (2, 45454545, 139.99, 20, 5, 50),
    (2, 67676767, 7.99, 65, 15, 150),
    (2, 89898989, 5.79, 45, 10, 120),
    /* Store 3 – San Jose */
    (3, 12121212, 1999.99, 6, 2, 12),
    (3, 13131313, 269.99, 20, 5, 40),
    (3, 33333333, 349.99, 2, 4, 40),
    (3, 55555555, 189.99, 15, 3, 30),
    (3, 98989898, 24.99, 30, 6, 80),
    /* Store 4 – Dallas */
    (4, 22222222, 649.99, 9, 2, 20),
    (4, 78787878, 5.99, 80, 20, 160),
    (4, 11121314, 99.99, 20, 5, 50),
    (4, 77777777, 3.49, 90, 20, 180),
    (4, 97979797, 24.99, 25, 5, 60),
    /* Store 5 – Miami */
    (5, 10101010, 69.99, 22, 4, 50),
    (5, 12131415, 99.99, 12, 3, 30),
    (5, 56565656, 24.99, 40, 10, 100),
    (5, 67676767, 7.99, 55, 15, 150),
    (5, 99999999, 12.99, 30, 6, 80),
    /* Store 6 – Chicago */
    (6, 14151617, 699.99, 7, 2, 15),
    (6, 12121212, 1999.99, 4, 1, 10),
    (6, 23232323, 799.99, 10, 2, 20),
    (6, 77777777, 3.49, 100, 20, 200),
    (6, 56565656, 24.99, 35, 7, 90),
    /* Store 7 – Seattle */
    (7, 11121314, 99.99, 18, 4, 40),
    (7, 23232323, 799.99, 8, 2, 20),
    (7, 66666666, 7.99, 70, 15, 150),
    (7, 89898989, 5.79, 35, 10, 100),
    (7, 97979797, 24.99, 20, 5, 60),
    /* Store 8 – Phoenix */
    (8, 55555555, 189.99, 20, 5, 50),
    (8, 45454545, 139.99, 18, 4, 40),
    (8, 88888888, 5.49, 60, 15, 150),
    (8, 66666666, 7.99, 50, 15, 150),
    (8, 34343434, 499.99, 10, 2, 20),
    (8, 98989898, 24.99, 25, 5, 70),
    /* Store 9 – Atlanta */
    (9, 44444444, 34.99, 35, 8, 80),
    (9, 56565656, 24.99, 45, 10, 100),
    (9, 99999999, 12.99, 40, 10, 100),
    (9, 89898989, 5.79, 40, 10, 100),
    (9, 11111111, 799.99, 10, 2, 20),
    /* Store 10 – Cleveland */
    (10, 10101010, 69.99, 25, 5, 60),
    (10, 12131415, 99.99, 14, 3, 30),
    (10, 98989898, 24.99, 28, 6, 70),
    (10, 88888888, 5.49, 45, 10, 120),
    (10, 97979797, 24.99, 18, 4, 50);

/*-----------------------------------------------------------------------
10.  CUSTOMERS  (20 demo shoppers)  + 10 payment cards
---------------------------------------------------------------------*/
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
    (1, 'Liam', 'Johnson', '518-555-1001', 21, TRUE, 1),
    (
        2,
        'Olivia',
        'Martinez',
        '585-555-1002',
        22,
        TRUE,
        2
    ),
    (
        3,
        'Noah',
        'Williams',
        '408-555-1003',
        23,
        TRUE,
        3
    ),
    (4, 'Emma', 'Brown', '214-555-1004', 24, TRUE, 4),
    (5, 'Oliver', 'Smith', '305-555-1005', 25, TRUE, 5),
    (6, 'Ava', 'Davis', '312-555-1006', 26, FALSE, 6),
    (
        7,
        'Elijah',
        'Miller',
        '206-555-1007',
        27,
        TRUE,
        7
    ),
    (
        8,
        'Sophia',
        'Wilson',
        '602-555-1008',
        28,
        TRUE,
        8
    ),
    (9, 'James', 'Moore', '404-555-1009', 29, FALSE, 9),
    (
        10,
        'Isabella',
        'Taylor',
        '216-555-1010',
        30,
        TRUE,
        10
    ),
    (
        11,
        'Benjamin',
        'Anderson',
        '518-555-1011',
        11,
        TRUE,
        1
    ),
    (12, 'Mia', 'Thomas', '585-555-1012', 12, FALSE, 2),
    (
        13,
        'Lucas',
        'Jackson',
        '408-555-1013',
        13,
        TRUE,
        3
    ),
    (
        14,
        'Charlotte',
        'White',
        '214-555-1014',
        14,
        TRUE,
        4
    ),
    (
        15,
        'Henry',
        'Harris',
        '305-555-1015',
        15,
        TRUE,
        5
    ),
    (
        16,
        'Amelia',
        'Martin',
        '312-555-1016',
        16,
        FALSE,
        6
    ),
    (
        17,
        'Alexander',
        'Thompson',
        '206-555-1017',
        17,
        TRUE,
        7
    ),
    (
        18,
        'Harper',
        'Garcia',
        '602-555-1018',
        18,
        TRUE,
        8
    ),
    (
        19,
        'Daniel',
        'Martinez',
        '404-555-1019',
        19,
        FALSE,
        9
    ),
    (
        20,
        'Evelyn',
        'Robinson',
        '216-555-1020',
        20,
        TRUE,
        10
    );

INSERT IGNORE INTO CustomerCard (card_hash, customer_id, addition_date)
VALUES
    ('2024-VISA-0001', 1, '2025-04-01'),
    ('2024-MC-0002', 2, '2025-04-02'),
    ('2024-AMEX-0003', 3, '2025-04-03'),
    ('2024-VISA-0004', 4, '2025-04-04'),
    ('2024-MC-0005', 5, '2025-04-05'),
    ('2024-VISA-0006', 7, '2025-04-06'),
    ('2024-MC-0007', 8, '2025-04-07'),
    ('2024-AMEX-0008', 10, '2025-04-08'),
    ('2024-VISA-0009', 11, '2025-04-09'),
    ('2024-MC-0010', 13, '2025-04-10');

/*-----------------------------------------------------------------------
11.  PRODUCT SUB-TYPE ROWS
---------------------------------------------------------------------*/
/* 11-A  ELECTRONIC_PRODUCT  (9 rows) */
INSERT IGNORE INTO Electronic_Product (upc, power_source, electronic_type, screen_size)
VALUES
    (11111111, 'Battery', 'Phone', NULL),
    (12121212, 'Battery', 'Laptop', '14"'),
    (13131313, 'Battery', 'Earbuds', NULL),
    (22222222, 'AC', 'Television', '55"'),
    (23232323, 'Battery', 'Tablet', '11"'),
    (33333333, 'Battery', 'Headphones', NULL),
    (34343434, 'AC', 'Game Console', NULL),
    (11121314, 'Battery', 'Mouse', NULL),
    (14151617, 'Battery', 'Laptop', '15"');

/* 11-B  CLOTHING_PRODUCT  (6 rows) */
INSERT IGNORE INTO Clothing_Product (
    upc,
    clothing_type,
    gender,
    color,
    material,
    clothing_size
)
VALUES
    (
        44444444,
        'Shirt',
        'Unisex',
        'Blue',
        'Polyester',
        'M'
    ),
    (
        45454545,
        'Running Shoes',
        'Men',
        'Grey',
        'Mesh',
        '9'
    ),
    (
        55555555,
        'Running Shoes',
        'Men',
        'Black',
        'Knit',
        '9'
    ),
    (
        56565656,
        'Crew Socks',
        'Unisex',
        'White',
        'Cotton',
        'L'
    ),
    (
        10101010,
        'Jeans',
        'Men',
        'Indigo',
        'Denim',
        '33×32'
    ),
    (
        12131415,
        'Jacket',
        'Unisex',
        'Blue',
        'Denim',
        'L'
    );

/* 11-C  CLEANING_PRODUCT  (3 rows) */
INSERT IGNORE INTO Cleaning_Product (upc, tool_type, use_location, hazard_label)
VALUES
    (
        99999999,
        'Liquid Detergent',
        'Laundry',
        'Irritant'
    ),
    (
        98989898,
        'Detergent Pods',
        'Laundry',
        'Keep away from children'
    ),
    (
        85858585,
        'Detergent Pods',
        'Laundry',
        'Keep away from children'
    );

/* 11-D  HEALTH_PRODUCT  (1 row) */
INSERT IGNORE INTO Health_Product (
    upc,
    health_product_type,
    use_directions,
    product_ingredients
)
VALUES
    (
        97979797,
        'Razor Blades',
        'Use with compatible handle. Replace when dull.',
        'Stainless steel, lubricant strip'
    );

/* 11-E  GROCERY_PRODUCT  (6 rows) */
INSERT IGNORE INTO Grocery_Product (upc, grocery_type, expiration, food_ingredients)
VALUES
    (
        66666666,
        'Soft Drink',
        '2026-01-01',
        'Carbonated water, HFCS, caramel color'
    ),
    (
        67676767,
        'Soft Drink',
        '2026-01-01',
        'Carbonated water, aspartame, caramel color'
    ),
    (
        77777777,
        'Baking',
        '2026-06-01',
        'Chocolate, sugar'
    ),
    (78787878, 'Water', '2027-01-01', 'Purified water'),
    (88888888, 'Cereal', '2025-12-31', 'Corn, sugar'),
    (
        89898989,
        'Cereal',
        '2025-12-31',
        'Corn, sugar, frosting'
    );

UPDATE Carries
SET
    quantity = 10
WHERE
    store_id = 4
    AND upc IN (77777777, 78787878);

SET
    FOREIGN_KEY_CHECKS = 1;