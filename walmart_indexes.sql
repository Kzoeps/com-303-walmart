-- Foreign Key Indexes: 


-- Customer
Create index indx_customer_address on customer(address_id);
create index indx_customer_address on customer(store_id);
create index indx_transaaction_payment on transaction_header(payment_id);

-- transactions 

create index indx_transaction_customer on transaction_header(customer_id);
create index indx_transaction_payment on transaction_header(payment_id);
create index indx_transaction_card on transaction_header(card_hash);

-- product 

create index indx_product_brand on product(brand_id);
create index indx_product_tax_category on product(tax_category_id);
create index indx_order_line_product on order_line_item(product_id);
create index indx_shipping_order on shipping(order_id); 

-- vendors 
create index indx_vendor_order_vendor on vendor_order(vendor_id);
create index indx_vendor_order_store on vendor_order(store_id);
create index indx_order_line_vendor on order_line(order_id);
create index indx_invoice_vendor on invoice(vendor_id);





-- Performance Index:

create index indx_product_name on product(item_name);
create index indx_brand_name on brand(brand_name);
create index indx_customer_name on customer(last_name, first_name);
create index indx_transaction_date on transaction_header(datetime);
create index indx_order_date on online_orders(order_date);
create index indx_vendor_order_date on vendor_order(order_date);
create index indx_product_expiration on grocery_product(expiration);


-- Composite Index:

create index indx_carries_store_product on carries(store_id, upc);
create index indx_transaction_store_date on transaction_header(store_id, datetime);
create index indx_line_item_transaction_product on transaction_line_item(transaction_id, product_id);

