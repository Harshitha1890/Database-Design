CREATE DATABASE global_logistics_system;
use global_logistics_system;
CREATE TABLE Clients (
    client_id INT PRIMARY KEY,
    name VARCHAR(100),
    address TEXT
);
CREATE TABLE Carriers (
    carrier_id INT PRIMARY KEY,
    name VARCHAR(100),
    type ENUM('Air', 'Land', 'Sea'),
    contact_info TEXT
);
CREATE TABLE Warehouses (
    warehouse_id INT PRIMARY KEY,
    location VARCHAR(255),
    capacity INT
);
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(100),
    role ENUM('Warehouse Staff', 'Carrier Crew'),
    warehouse_id INT,
    carrier_id INT,
    CONSTRAINT chk_one_assignment CHECK (
        (warehouse_id IS NOT NULL AND carrier_id IS NULL)
        OR (warehouse_id IS NULL AND carrier_id IS NOT NULL)
    ),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id),
    FOREIGN KEY (carrier_id) REFERENCES Carriers(carrier_id)
);
CREATE TABLE Shipments (
    shipment_id INT PRIMARY KEY,
    origin VARCHAR(255),
    destination VARCHAR(255),
    weight DECIMAL(10,2),
    content_description TEXT,
    shipment_date DATE
);
CREATE TABLE ShipmentClients (
    shipment_id INT,
    client_id INT,
    role ENUM('Sender', 'Receiver'),
    PRIMARY KEY (shipment_id, client_id, role),
    FOREIGN KEY (shipment_id) REFERENCES Shipments(shipment_id),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id)
);
CREATE TABLE ShipmentRoutes (
    route_id INT PRIMARY KEY AUTO_INCREMENT,
    shipment_id INT,
    carrier_id INT,
    start_location VARCHAR(255),
    end_location VARCHAR(255),
    leg_order INT,
    FOREIGN KEY (shipment_id) REFERENCES Shipments(shipment_id),
    FOREIGN KEY (carrier_id) REFERENCES Carriers(carrier_id)
);
CREATE TABLE ShipmentWarehouses (
    shipment_id INT,
    warehouse_id INT,
    storage_date DATE,
    PRIMARY KEY (shipment_id, warehouse_id, storage_date),
    FOREIGN KEY (shipment_id) REFERENCES Shipments(shipment_id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id)
);
-- Clients
INSERT INTO Clients VALUES 
(1, 'Globex Corporation', 'New York, USA'),
(2, 'Initech Ltd.', 'London, UK');

-- Carriers
INSERT INTO Carriers VALUES 
(1, 'SkyFreight Express', 'Air', 'skyfreight@carrier.com'),
(2, 'TransLand Logistics', 'Land', 'contact@transland.com');

-- Warehouses
INSERT INTO Warehouses VALUES 
(1, 'Delhi, India', 1000),
(2, 'Dubai, UAE', 1500);

-- Employees
INSERT INTO Employees VALUES
(101, 'Amit Sharma', 'Warehouse Staff', 1, NULL),
(102, 'Sarah Green', 'Carrier Crew', NULL, 1);

-- Shipments
INSERT INTO Shipments VALUES
(5001, 'Chennai, India', 'Berlin, Germany', 120.50, 'Electronics and gadgets', '2025-06-10'),
(5002, 'Seattle, USA', 'Tokyo, Japan', 300.00, 'Pharmaceuticals', '2025-06-12');

-- ShipmentClients (Sender/Receiver)
INSERT INTO ShipmentClients VALUES 
(5001, 1, 'Sender'),
(5001, 2, 'Receiver'),
(5002, 2, 'Sender'),
(5002, 1, 'Receiver');

-- ShipmentRoutes
INSERT INTO ShipmentRoutes (shipment_id, carrier_id, start_location, end_location, leg_order) VALUES 
(5001, 2, 'Chennai, India', 'Delhi, India', 1),
(5001, 1, 'Delhi, India', 'Berlin, Germany', 2),
(5002, 1, 'Seattle, USA', 'Tokyo, Japan', 1);

-- ShipmentWarehouses
INSERT INTO ShipmentWarehouses VALUES 
(5001, 1, '2025-06-10'),
(5001, 2, '2025-06-11');