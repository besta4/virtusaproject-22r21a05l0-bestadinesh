CREATE DATABASE SwiftShipDB;
USE SwiftShipDB;

CREATE TABLE Partners (
    PartnerID INT PRIMARY KEY AUTO_INCREMENT,
    PartnerName VARCHAR(100),
    ContactEmail VARCHAR(100)
);

CREATE TABLE Shipments (
    ShipmentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    PartnerID INT,
    SourceCity VARCHAR(100),
    DestinationCity VARCHAR(100),
    PromisedDate DATE,
    ActualDeliveryDate DATE,
    Status VARCHAR(50),
    FOREIGN KEY (PartnerID) REFERENCES Partners(PartnerID)
);

CREATE TABLE DeliveryLogs (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    ShipmentID INT,
    LogDate DATETIME,
    Location VARCHAR(100),
    StatusUpdate VARCHAR(100),
    FOREIGN KEY (ShipmentID) REFERENCES Shipments(ShipmentID)
);




INSERT INTO Partners (PartnerName, ContactEmail) VALUES
('FastTrack Logistics', 'fast@swift.com'),
('QuickMove Couriers', 'quick@swift.com'),
('SpeedX Delivery', 'speedx@swift.com');


INSERT INTO Shipments 
(OrderID, PartnerID, SourceCity, DestinationCity, PromisedDate, ActualDeliveryDate, Status)
VALUES
(101, 1, 'Hyderabad', 'Bangalore', '2026-04-10', '2026-04-11', 'Delivered'),
(102, 2, 'Hyderabad', 'Chennai', '2026-04-12', '2026-04-12', 'Delivered'),
(103, 1, 'Hyderabad', 'Mumbai', '2026-04-15', '2026-04-18', 'Delayed'),
(104, 3, 'Hyderabad', 'Bangalore', '2026-04-11', '2026-04-10', 'Delivered'),
(105, 2, 'Hyderabad', 'Delhi', '2026-04-16', '2026-04-20', 'Returned'),
(106, 3, 'Hyderabad', 'Chennai', '2026-04-14', '2026-04-14', 'Delivered');


INSERT INTO DeliveryLogs (ShipmentID, LogDate, Location, StatusUpdate) VALUES
(1, NOW(), 'Hyderabad Hub', 'Dispatched'),
(1, NOW(), 'Bangalore Hub', 'Delivered'),
(3, NOW(), 'Mumbai Hub', 'Delayed'),
(5, NOW(), 'Delhi Hub', 'Returned');


SELECT 
    ShipmentID,
    PartnerID,
    PromisedDate,
    ActualDeliveryDate
FROM Shipments
WHERE ActualDeliveryDate > PromisedDate;


SELECT 
    p.PartnerName,
    COUNT(CASE WHEN s.Status = 'Delivered' THEN 1 END) AS SuccessfulDeliveries,
    COUNT(CASE WHEN s.Status = 'Returned' THEN 1 END) AS ReturnedDeliveries
FROM Partners p
JOIN Shipments s ON p.PartnerID = s.PartnerID
GROUP BY p.PartnerName;


SELECT 
    DestinationCity,
    COUNT(*) AS TotalOrders
FROM Shipments
WHERE PromisedDate >= CURDATE() - INTERVAL 30 DAY
GROUP BY DestinationCity
ORDER BY TotalOrders DESC
LIMIT 1;


SELECT 
    p.PartnerName,
    COUNT(*) AS TotalShipments,
    
    SUM(CASE 
        WHEN s.ActualDeliveryDate > s.PromisedDate THEN 1 
        ELSE 0 
    END) AS DelayedShipments,

    ROUND(
        (SUM(CASE WHEN s.Status = 'Delivered' THEN 1 ELSE 0 END) / COUNT(*)) * 100, 
        2
    ) AS SuccessRatePercentage

FROM Partners p
JOIN Shipments s ON p.PartnerID = s.PartnerID
GROUP BY p.PartnerName
ORDER BY DelayedShipments ASC;