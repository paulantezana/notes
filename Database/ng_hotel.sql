CREATE TABLE maintenance_services(
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    description varchar(128) NOT NULL,
    icon varchar(64) DEFAULT '',

    state tinyint(4) DEFAULT 1,
    updated_at datetime DEFAULT NULL,
    created_at datetime DEFAULT NULL,
    created_user varchar(64) DEFAULT '',
    updated_user varchar(64) DEFAULT ''
) ENGINE=InnoDB;

CREATE TABLE maintenance_categories(
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    description varchar(128) NOT NULL,
    
    state tinyint(4) DEFAULT 1,
    updated_at datetime DEFAULT NULL,
    created_at datetime DEFAULT NULL,
    created_user varchar(64) DEFAULT '',
    updated_user varchar(64) DEFAULT '' 
) ENGINE=InnoDB;



CREATE TABLE maintenance_room_types(
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name varchar(128) NOT NULL,
    description varchar(128) NOT NULL,
    number_guest INT DEFAULT 0,
    max_guest INT DEFAULT 0,
    number_bed INT DEFAULT 0,
    national_price double(11,2) DEFAULT 0.00,
    foreign_price double(11,2) DEFAULT 0.00,
    sort_order int DEFAULT 0,
    is_internal tinyint(4) DEFAULT 0,

    company_id INT NOT NULL,

    state tinyint(4) DEFAULT 1,
    updated_at datetime DEFAULT NULL,
    created_at datetime DEFAULT NULL,
    created_user varchar(64) DEFAULT '',
    updated_user varchar(64) DEFAULT '',
    CONSTRAINT fk_room_types_companies FOREIGN KEY (company_id) REFERENCES app_companies (id)
);

CREATE TABLE maintenance_rooms(
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    description varchar(32) NOT NULL,

    room_type_id INT NOT NULL,

    state tinyint(4) DEFAULT 1,
    updated_at datetime DEFAULT NULL,
    created_at datetime DEFAULT NULL,
    created_user varchar(64) DEFAULT '',
    updated_user varchar(64) DEFAULT '',

    CONSTRAINT fk_rooms_room_types FOREIGN KEY (room_type_id) REFERENCES maintenance_room_types (id)
) ENGINE=InnoDB;

CREATE TABLE maintenance_room_type_images(
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    url_path varchar(128) NOT NULL,
    sort_order int not null,

    room_type_id INT NOT NULL,

    state tinyint(4) DEFAULT 1,
    updated_at datetime DEFAULT NULL,
    created_at datetime DEFAULT NULL,
    created_user varchar(64) DEFAULT '',
    updated_user varchar(64) DEFAULT '',

    CONSTRAINT fk_room_type_images_room_types FOREIGN KEY (room_type_id) REFERENCES maintenance_room_types (id)
) ENGINE=InnoDB;


CREATE TABLE maintenance_room_type_services(
    room_type_id INT NOT NULL,
    service_id INT NOT NULL,
    CONSTRAINT fk_room_type_services_room_types FOREIGN KEY (room_type_id) REFERENCES maintenance_room_types (id),
    CONSTRAINT fk_room_type_services_services FOREIGN KEY (service_id) REFERENCES maintenance_services (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE maintenance_room_type_categories(
    room_type_id INT NOT NULL,
    category_id INT NOT NULL,
    CONSTRAINT fk_room_type_categories_room_types FOREIGN KEY (room_type_id) REFERENCES maintenance_room_types (id),
    CONSTRAINT fk_room_type_categories_categories FOREIGN KEY (category_id) REFERENCES maintenance_categories (id)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- Tarifas de temporada y cambios de tarifa temporales
CREATE TABLE maintenance_seasonal_prices(
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    description varchar(128) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
    valid_mon TINYINT DEFAULT 0,
    valid_tue TINYINT DEFAULT 0,
    valid_wed TINYINT DEFAULT 0,
    valid_thu TINYINT DEFAULT 0,
    valid_fri TINYINT DEFAULT 0,
    valid_sat TINYINT DEFAULT 0,

    company_id INT NOT NULL,

    state tinyint(4) DEFAULT 1,
    updated_at datetime DEFAULT NULL,
    created_at datetime DEFAULT NULL,
    created_user varchar(64) DEFAULT '',
    updated_user varchar(64) DEFAULT '',

    CONSTRAINT fk_seasonal_prices_companies FOREIGN KEY (company_id) REFERENCES app_companies (id)
) ENGINE=InnoDB;


CREATE TABLE maintenance_seasonal_price_room_types(
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    national_price double(11,2) DEFAULT 0.00,
    foreign_price double(11,2) DEFAULT 0.00,
    
    room_type_id INT NOT NULL,
    seasonal_price_id INT NOT NULL,

    state tinyint(4) DEFAULT 1,
    updated_at datetime DEFAULT NULL,
    created_at datetime DEFAULT NULL,
    created_user varchar(64) DEFAULT '',
    updated_user varchar(64) DEFAULT '',

    CONSTRAINT fk_seasonal_price_room_types_room_types FOREIGN KEY (room_type_id) REFERENCES maintenance_room_types (id),
    CONSTRAINT fk_seasonal_price_room_types_seasonal_prices FOREIGN KEY (seasonal_price_id) REFERENCES maintenance_seasonal_prices (id)
) ENGINE=InnoDB;

-- Listas de precios alternativos 
CREATE TABLE maintenance_alternative_prices(
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    description varchar(128) NOT NULL,

    company_id INT NOT NULL,

    state tinyint(4) DEFAULT 1,
    updated_at datetime DEFAULT NULL,
    created_at datetime DEFAULT NULL,
    created_user varchar(64) DEFAULT '',
    updated_user varchar(64) DEFAULT '',

    CONSTRAINT fk_alternative_prices_companies FOREIGN KEY (company_id) REFERENCES app_companies (id)
) ENGINE=InnoDB;


CREATE TABLE maintenance_alternative_price_room_types(
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    national_price double(11,2) DEFAULT 0.00,
    foreign_price double(11,2) DEFAULT 0.00,
    
    room_type_id INT NOT NULL,
    alternative_price_id INT NOT NULL,

    state tinyint(4) DEFAULT 1,
    updated_at datetime DEFAULT NULL,
    created_at datetime DEFAULT NULL,
    created_user varchar(64) DEFAULT '',
    updated_user varchar(64) DEFAULT '',

    CONSTRAINT fk_alternative_price_room_types_room_types FOREIGN KEY (room_type_id) REFERENCES maintenance_room_types (id),
    CONSTRAINT fk_alternative_price_room_types_alternative_prices FOREIGN KEY (alternative_price_id) REFERENCES maintenance_alternative_prices (id)
) ENGINE=InnoDB;

CREATE TABLE setting_discount_types(
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    description varchar(128) NOT NULL,

    state tinyint(4) DEFAULT 1,
    updated_at datetime DEFAULT NULL,
    created_at datetime DEFAULT NULL,
    created_user varchar(64) DEFAULT '',
    updated_user varchar(64) DEFAULT ''
) ENGINE=InnoDB;

-- Descuento para estadías más largas


-- Códigos de cupón 
CREATE TABLE maintenance_cupon_prices(
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    code varchar(32) NOT NULL,
    description varchar(128) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,

    overall_percentage_room INT DEFAULT 0.00,
    overall_percentage_aditional INT DEFAULT 0.00,

    discount_type_id INT NOT NULL,
    company_id INT NOT NULL,

    state tinyint(4) DEFAULT 1,
    updated_at datetime DEFAULT NULL,
    created_at datetime DEFAULT NULL,
    created_user varchar(64) DEFAULT '',
    updated_user varchar(64) DEFAULT '',

    CONSTRAINT fk_cupon_prices_companies FOREIGN KEY (company_id) REFERENCES app_companies (id),
    CONSTRAINT fk_cupon_prices_discount_types FOREIGN KEY (discount_type_id) REFERENCES setting_discount_types (id)
) ENGINE=InnoDB;

CREATE TABLE maintenance_cupon_price_room_types(
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    national_value double(11,2) DEFAULT 0.00,
    foreign_value double(11,2) DEFAULT 0.00,
    
    room_type_id INT NOT NULL,
    cupon_price_id INT NOT NULL,

    state tinyint(4) DEFAULT 1,
    updated_at datetime DEFAULT NULL,
    created_at datetime DEFAULT NULL,
    created_user varchar(64) DEFAULT '',
    updated_user varchar(64) DEFAULT '',

    CONSTRAINT fk_cupon_price_room_types_room_types FOREIGN KEY (room_type_id) REFERENCES maintenance_room_types (id),
    CONSTRAINT fk_cupon_price_room_types_cupon_prices FOREIGN KEY (cupon_price_id) REFERENCES maintenance_cupon_prices (id)
) ENGINE=InnoDB;


CREATE TABLE maintenance_activities(
    id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    description varchar(128) NOT NULL,
    frequency INT NOT NULL,
    checkin TINYINT DEFAULT 0,
    stay TINYINT DEFAULT 0,
    checkout TINYINT DEFAULT 0,
    even TINYINT DEFAULT 0,

    company_id int not null,

    state tinyint(4) DEFAULT 1,
    updated_at datetime DEFAULT NULL,
    created_at datetime DEFAULT NULL,
    created_user varchar(64) DEFAULT '',
    updated_user varchar(64) DEFAULT '',

    CONSTRAINT fk_activities_companies FOREIGN KEY (company_id) REFERENCES app_companies (id)
) ENGINE=InnoDB;



CREATE TABLE maintenance_bookings(
    id bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
    description varchar(128) DEFAULT '',
    full_name varchar(128) DEFAULT '',
    position varchar(64) DEFAULT '',
    address varchar(128) DEFAULT '',
    phone  varchar(32) DEFAULT '',
    email  varchar(64) DEFAULT '',

    location_id int not null,
    company_id int not null,

    state tinyint(4) DEFAULT 1,
    updated_at datetime DEFAULT NULL,
    created_at datetime DEFAULT NULL,
    created_user varchar(64) DEFAULT '',
    updated_user varchar(64) DEFAULT '',

    CONSTRAINT fk_bookings_companies FOREIGN KEY (company_id) REFERENCES app_companies (id)
) ENGINE=InnoDB;

CREATE TABLE maintenance_booking_histories(
    id bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
    description varchar(255) NOT NULL,

    date_time DATETIME NOT NULL,
    booking_id INT NOT NULL,
    user_id INT NOT NULL,

    state tinyint(4) DEFAULT 1,
    updated_at datetime DEFAULT NULL,
    created_at datetime DEFAULT NULL,
    created_user varchar(64) DEFAULT '',
    updated_user varchar(64) DEFAULT '',

    CONSTRAINT fk_bookings_companies FOREIGN KEY (company_id) REFERENCES app_companies (id)
) ENGINE=InnoDB;


CREATE TABLE maintenance_booking_rooms(
    id bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
    check_in_date_time DATETIME NOT NULL,
    check_out_date_time DATETIME NOT NULL,
    number_guest INT DEFAULT 0,
    price double(11,2) DEFAULT 0.00,
    
    currency_id INT NOT NULL,
    room_id INT NOT NULL,
    booking_id INT NOT NULL,
    booking_room_state_id INT NOT NULL,

    state tinyint(4) DEFAULT 1,
    updated_at datetime DEFAULT NULL,
    created_at datetime DEFAULT NULL,
    created_user varchar(64) DEFAULT '',
    updated_user varchar(64) DEFAULT '',

    -- CONSTRAINT fk_bookings_companies FOREIGN KEY (company_id) REFERENCES app_companies (id)
) ENGINE=InnoDB;

CREATE TABLE maintenance_booking_room_cutomers(
    id bigint NOT NULL AUTO_INCREMENT PRIMARY KEY,
    
    booking_room_id INT NOT NULL,
    customer_id INT NOT NULL,

    state tinyint(4) DEFAULT 1,
    updated_at datetime DEFAULT NULL,
    created_at datetime DEFAULT NULL,
    created_user varchar(64) DEFAULT '',
    updated_user varchar(64) DEFAULT '',

    -- CONSTRAINT fk_bookings_companies FOREIGN KEY (company_id) REFERENCES app_companies (id)
) ENGINE=InnoDB;