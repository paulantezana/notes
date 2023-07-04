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
    price double(11,2) DEFAULT 0.00,
    sort_order int DEFAULT 0,
    is_internal tinyint(4) DEFAULT 0,

    state tinyint(4) DEFAULT 1,
    updated_at datetime DEFAULT NULL,
    created_at datetime DEFAULT NULL,
    created_user varchar(64) DEFAULT '',
    updated_user varchar(64) DEFAULT '' 
);

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
-- prices-seasonal-price

-- Listas de precios alternativos 
-- price-list

-- Descuento para estadías más largas


-- Códigos de cupón 
-- prices-coupon-code