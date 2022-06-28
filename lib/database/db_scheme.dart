class DBScheme {
  static const sessionTable =
      'CREATE TABLE session_data(key TEXT PRIMARY KEY, value TEXT)';

  static const eventsTable = ''' CREATE TABLE events (
    id character varying(32) PRIMARY KEY NOT NULL,
    event_code character varying(50),
    name character varying(250),
    start_date_time bigint,
    end_date_time bigint,
    delivery character varying(100),
    link character varying(255),
    address_line_1 character varying(255),
    address_line_2 character varying(255),
    country character varying(50),
    state character varying(50),
    city character varying(50),
    zip_code character varying(10),
    contact_name character varying(200),
    contact_email character varying(250),
    contact_phone_num_country_code character varying(5),
    contact_phone_number character varying(20),
    key character varying(50),
    "values" character varying(500) DEFAULT empty,
    display_additional_payment_field boolean DEFAULT false,
    additional_payment_field_label character varying(50),
    activated boolean DEFAULT true,
    created_by character varying(32),
    created_at bigint,
    updated_by character varying(32),
    updated_at bigint,
    deleted boolean DEFAULT false,
    franchise_id character varying(32),
    minimum_order_amount numeric(12,2) DEFAULT 0,
    event_status character varying(50),
    special_instruction_label character varying(250),
    display_gratuity_field boolean DEFAULT false,
    gratuity_field_label character varying(50),
    campaign_id character varying(32),
    enable_donation boolean DEFAULT false,
    donation_field_label character varying(50),
    asset_id character varying(32),
    weather_type character varying(50),
    payment_term character varying(32),
    secondary_contact_name character varying(100),
    secondary_contact_email character varying(250),
    secondary_contact_phone_num_country_code character varying(5),
    secondary_contact_phone_number character varying(20),
    notes text,
    event_type character varying(20),
    pre_order boolean DEFAULT false NOT NULL,
    radius integer DEFAULT 0,
    time_slot integer DEFAULT 0,
    max_order_in_slot integer DEFAULT 0,
    location_notes character varying,
    order_attribute character varying,
    minimum_delivery_time integer DEFAULT 0,
    start_address character varying(255),
    use_time_slot boolean DEFAULT false NOT NULL,
    max_allowed_orders integer DEFAULT 0,
    delivery_message character varying,
    recipient_name_label character varying(250),
    order_start_date_time bigint,
    order_end_date_time bigint,
    sms_notification boolean DEFAULT false,
    email_notification boolean DEFAULT false,
    client_id character varying(32),
    recurring_type character varying(100),
    days character varying(250),
    monthly_date_time bigint,
    expiry_date bigint,
    last_day_of_month boolean DEFAULT false,
    series_id character varying(32),
    manual_status character varying(50),
    entry_fee numeric(12,2),
    cash_amount numeric(12,2),
    check_amount numeric(12,2),
    cc_amount numeric(12,2),
    event_sales_collected numeric(12,2),
    giveback_subtotal numeric(12,2),
    sales_tax numeric(12,2),
    giveback numeric(12,2),
    tip_amount numeric(12,2),
    net_event_sales numeric(12,2),
    event_sales numeric(12,2),
    collected numeric(12,2),
    balance numeric(12,2),
    giveback_paid boolean,
    client_invoice boolean,
    giveback_settled_date bigint,
    invoice_settled_date bigint,
    giveback_check character varying(100),
    thank_you_email boolean,
    event_sales_type_id character varying(50),
    minimum_fee numeric(12,2) DEFAULT 0,
    keep_cup_count boolean DEFAULT false,
    cup_count_total numeric(12,2) DEFAULT 0,
    package_fee numeric(12,2) DEFAULT 0,
    pre_pay boolean DEFAULT false NOT NULL,
    contact_title character varying(50),
    client_industries_type_id character varying(32),
    invoice_check character varying(32),
    old_db_event_id character varying(32),
    confirmed_email_sent boolean DEFAULT false NOT NULL
)''';

  static const eventItemTable = '''CREATE TABLE event_items (
  id character varying(32) PRIMARY KEY NOT NULL,
  item_id character varying(32),
  event_id character varying(32),
  price numeric(12,2),
  created_by character varying(32),
  created_at bigint,
  updated_by character varying(32),
  updated_at bigint,
  deleted boolean DEFAULT false,
  sequence integer DEFAULT 0,
  gift boolean DEFAULT false,
  item_category_id character varying(32),
  sold_qty integer DEFAULT 0,
  comp_qty integer DEFAULT 0
  )''';

  static const foodExtraItemsTable = '''CREATE TABLE food_extra_items (
    id character varying(32) NOT NULL,
    food_extra_item_category_id character varying(32) NOT NULL,
    event_id character varying(32) NOT NULL,
    item_id character varying(32) NOT NULL,
    item_name character varying(50) NOT NULL,
    selling_price numeric(12,2) DEFAULT 0 NOT NULL,
    selection character varying(50) NOT NULL,
    sequence bigint,
    image_file_id character varying(50),
    min_qty_allowed bigint,
    max_qty_allowed bigint,
    activated boolean DEFAULT true,
    created_by character varying(32),
    created_at bigint,
    updated_by character varying(32),
    updated_at bigint,
    deleted boolean DEFAULT false,
    PRIMARY KEY (id, event_id, item_id)
)''';

  static const itemCategoriesTable = '''CREATE TABLE item_categories (
    id character varying(32) NOT NULL,
    event_id character varying(32) NOT NULL,
    category_code character varying(20),
    category_name character varying(50),
    description character varying(250),
    activated boolean DEFAULT true,
    created_by character varying(32),
    created_at bigint,
    updated_by character varying(32),
    updated_at bigint,
    deleted boolean DEFAULT false,
    franchise_id character varying(32),
    PRIMARY KEY (id, event_id)
)''';

  static const itemsTable = '''CREATE TABLE items (
    id character varying(32) NOT NULL,
    event_id character varying(50) NOT NULL,
    item_category_id character varying(32),
    image_file_id character varying(50),
    item_code character varying(50),
    name character varying(50),
    description character varying(250),
    price numeric(12,2),
    activated boolean DEFAULT true,
    sequence bigint,
    created_by character varying(32),
    created_at bigint,
    updated_by character varying(32),
    updated_at bigint,
    deleted boolean DEFAULT false,
    franchise_id character varying(32),
    PRIMARY KEY (id, event_id)
)''';

  static const orderItemsTable = '''CREATE TABLE order_items (
    id character varying(32) NOT NULL,
    order_id character varying(32),
    item_id character varying(32),
    name character varying(50),
    quantity integer,
    unit_price numeric(12,2),
    total_amount numeric(12,2),
    created_by character varying(32),
    created_at bigint,
    updated_by character varying(32),
    updated_at bigint,
    deleted boolean DEFAULT false,
    item_category_id character varying(32),
    "values" character varying,
    key character varying,
    recipient_name character varying
)''';

  static const ordersTable = '''CREATE TABLE orders (
    id character varying(32) NOT NULL,
    event_id character varying(32),
    order_code character varying(20),
    first_name character varying(50),
    last_name character varying(50),
    email character varying(255),
    phone_num_country_code character varying(5),
    phone_number character varying(20),
    address_line_1 character varying(255),
    address_line_2 character varying(255),
    country character varying(50),
    state character varying(50),
    city character varying(50),
    zip_code character varying(10),
    key character varying(50),
    "values" character varying(250),
    special_instructions character varying(250),
    order_status character varying(20),
    created_by character varying(32),
    created_at bigint,
    updated_by character varying(32),
    updated_at bigint,
    deleted boolean DEFAULT false,
    franchise_id character varying(32),
    payment_status character varying(20),
    refund_amount numeric(12,2) DEFAULT 0,
    recipient_name character varying(50),
    campaign_id character varying(32),
    anonymous_id character varying(32),
    campaign_share_refund boolean DEFAULT false,
    order_amount_refund boolean DEFAULT false,
    total_refund boolean DEFAULT false,
    payment_term character varying(32),
    slot_interval_1 bigint,
    slot_interval_2 bigint,
    order_date bigint,
    pre_order boolean DEFAULT false NOT NULL,
    order_attribute character varying,
    partial_refund boolean DEFAULT false,
    admin_refund_amount numeric(12,2) DEFAULT 0,
    franchise_refund_amount numeric(12,2) DEFAULT 0,
    user_id character varying(32),
    payment_module character varying(50),
    created_by_role_code character varying(50),
    sub_account_id character varying(32),
    user_address_id character varying(32)
)''';

  static const savedOrders = '''CREATE TABLE saved_orders (
   event_id character varying(50),
   card_id character varying(50),
   order_code character varying(50), 
   order_id character varying(50) PRIMARY KEY NOT NULL,
   customer_name character varying(100),
   phone_number character varying(15),
   phone_country_code character varying(10),
   address1 character varying(255),
   address2 character varying(255),
   country character varying(100),
   state character varying(100),
   city character varying(100),
   zip_code character varying(50),
   order_date bigint,
   tip numeric(12,2),
   discount numeric(12,2),
   food_cost numeric(12,2),
   total_amount numeric(12,2),
   grand_total numeric(12,2),
   payment character varying(50),
   order_status character varying(50),
   deleted boolean DEFAULT false,
   payment_term character varying(100),
   refund_amount character varying(50),
   pos_payment_method character varying(50)
)''';
  static const savedOrdersItem = '''CREATE TABLE saved_orders_item (
   order_id character varying(50),
   item_id character varying(100),
   item_name character varying(100),
   quantity INTEGER,
   unit_price numeric(12,2),
   total_price numeric(12,2),
   item_category_id character varying(50),
   deleted boolean DEFAULT false,
   PRIMARY KEY (order_id, item_id)
)''';

  static const savedOrdersExtraItems =
      '''CREATE TABLE saved_orders_extra_items (
   order_id character varying(50),
   item_id character varying(100),
   extra_food_item_id character varying(15),
   extra_food_item_name character varying(15),
   extra_food_item_category_id character varying(15),
   quantity INTEGER,
   unit_price numeric(12,2),
   total_price numeric(12,2),
   deleted boolean DEFAULT false,
   PRIMARY KEY (order_id, item_id,extra_food_item_id)
)''';

  //Not in USE
  static const eventFoodExtraItemMappingTable =
      '''CREATE TABLE event_food_extra_item_mappings (
    id character varying(32) NOT NULL,
    event_item_id character varying(32) NOT NULL,
    event_id character varying(32) NOT NULL,
    item_category_id character varying(32),
    item_id character varying(32) NOT NULL,
    food_extra_category_id character varying(32) NOT NULL,
    food_extra_item_id character varying(32) NOT NULL,
    activated boolean DEFAULT true,
    created_by character varying(32),
    created_at bigint,
    updated_by character varying(32),
    updated_at bigint,
    deleted boolean DEFAULT false,
    price numeric(12,2),
    sequence integer DEFAULT 0
)''';

  //Not in USE
  static const foodExtraItemsCategoriesTable =
      '''CREATE TABLE food_extra_item_categories (
    id character varying(32) NOT NULL,
    category_name character varying(100) NOT NULL,
    type character varying(50) NOT NULL,
    min_qty_allowed bigint,
    max_qty_allowed bigint,
    activated boolean DEFAULT true,
    created_by character varying(32),
    created_at bigint,
    updated_by character varying(32),
    updated_at bigint,
    deleted boolean DEFAULT false,
    franchise_id character varying(32)
)''';

  //Not in USE
  static const itemFoodExtraMappingMasterTable =
      '''CREATE TABLE item_food_extra_mapping_masters (
    id character varying(32) NOT NULL,
    item_category_id character varying(32),
    item_id character varying(32) NOT NULL,
    food_extra_category_id character varying(32) NOT NULL,
    food_extra_item_id character varying(32) NOT NULL,
    price numeric(12,2),
    sequence integer DEFAULT 0,
    activated boolean DEFAULT true,
    created_by character varying(32),
    created_at bigint,
    updated_by character varying(32),
    updated_at bigint,
    deleted boolean DEFAULT false
)''';

  //Not in USE
  static const orderFoodExtraItemMappingTable =
      '''CREATE TABLE order_food_extra_item_mappings (
    id character varying(32) NOT NULL,
    order_id character varying(32) NOT NULL,
    order_item_id character varying(32) NOT NULL,
    item_category_id character varying(32),
    food_extra_category_id character varying(32) NOT NULL,
    food_extra_item_id character varying(32) NOT NULL,
    special_instructions character varying(250),
    quantity integer,
    unit_price numeric(12,2),
    total_amount numeric(12,2),
    created_by character varying(32),
    created_at bigint,
    updated_by character varying(32),
    updated_at bigint,
    deleted boolean DEFAULT false
)''';
}
