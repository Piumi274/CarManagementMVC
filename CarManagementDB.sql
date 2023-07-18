---------------------------------------- Create Tables ----------------------------------------
-- Create Customer table
CREATE TABLE [dbo].[Customer] (
    [Id]    INT           NOT NULL,
    [name]  VARCHAR (50)  NOT NULL,
    [email] VARCHAR (100) NOT NULL,
    [phone] VARCHAR (20)  NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

-- Create Vehicle table
CREATE TABLE [dbo].[Vehicle] (
    [Id]               INT            NOT NULL,
    [make]             VARCHAR (50)   NOT NULL,
    [model]            VARCHAR (50)   NOT NULL,
    [year]             INT            NOT NULL,
    [plateNumber]      VARCHAR (20)   NOT NULL,
    [rentalRatePerDay] DECIMAL (8, 2) NOT NULL,
    [status]           VARCHAR (20)   NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [CK_VehicleStatus] CHECK ([status]='in maintenance' OR [status]='rented' OR [status]='available')
);

-- Create Rental table
CREATE TABLE [dbo].[Rental] (
    [Id]              INT             NOT NULL,
    [customerId]      INT             NOT NULL,
    [vehicleId]       INT             NOT NULL,
    [rentalStartDate] DATETIME        NOT NULL,
    [rentalEndDate]   DATETIME        NOT NULL,
    [totalCost]       DECIMAL (10, 2) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Rental_Customer] FOREIGN KEY ([customerId]) REFERENCES [dbo].[Customer] ([Id]),
    CONSTRAINT [FK_Rental_Vehicle] FOREIGN KEY ([vehicleId]) REFERENCES [dbo].[Vehicle] ([Id])
);


---------------------------------------- Triggers ----------------------------------------
GO
-- Trigger to update the total cost when rental dates are modified
CREATE TRIGGER [UpdateTotalCost]
	ON [dbo].[Rental]
	AFTER UPDATE
	AS
	BEGIN
		UPDATE [dbo].[Rental]
		SET totalCost = rentalRatePerDay * (DATEDIFF(day, rentalStartDate, rentalEndDate) + 1)
		FROM [dbo].[Rental] r
		INNER JOIN [dbo].[Vehicle] v ON r.vehicleId = v.Id
		WHERE r.Id IN (SELECT Id FROM inserted) -- Check only the updated records
	END

GO
-- Trigger to delete rentals when a customer is deleted
CREATE TRIGGER [DeleteCustomerRentals]
	ON [dbo].[Customer]
	INSTEAD OF DELETE
	AS
	BEGIN
		DELETE FROM [dbo].[Rental]
		WHERE customerId IN (SELECT Id FROM deleted) -- Delete related rentals
		DELETE FROM [dbo].[Customer]
		WHERE Id IN (SELECT Id FROM deleted) -- Delete the customer
	END


---------------------------------------- Views ----------------------------------------
GO
-- View to get the total revenue per month
CREATE VIEW [dbo].[MonthlyRevenue]
	AS SELECT MONTH(rentalStartDate) AS month, YEAR(rentalStartDate) AS year, SUM(totalCost) AS revenue
	FROM [dbo].[Rental]
	GROUP BY MONTH(rentalStartDate), YEAR(rentalStartDate);

GO
-- View to get the list of rentals with customer and vehicle details
CREATE VIEW [dbo].[RentalDetails]
	AS SELECT r.Id AS rentalId, c.name AS customerName, v.make, v.model, r.rentalStartDate, r.rentalEndDate
	FROM [dbo].[Rental] r
	INNER JOIN [dbo].[Customer] c ON r.customerId = c.Id
	INNER JOIN [dbo].[Vehicle] v ON r.vehicleId = v.Id;


---------------------------------------- Procedures ----------------------------------------
GO
-- Procedure to calculate the rental cost for a given rental ID
CREATE PROCEDURE calculate_rental_cost
(
    @rentalId INT,
    @cost DECIMAL(10, 2) OUTPUT
)
AS
BEGIN
    SELECT @cost = rentalRatePerDay * (DATEDIFF(day, rentalStartDate, rentalEndDate) + 1)
    FROM [dbo].[Rental] r
    INNER JOIN [dbo].[Vehicle] v ON r.vehicleId = v.Id
    WHERE r.Id = @rentalId;
END
GO

-- Procedure to update the rental end date for a given rental ID
CREATE PROCEDURE update_rental_end_date
(
    @rentalId INT,
    @newEndDate DATETIME
)
AS
BEGIN
    UPDATE [dbo].[Rental]
    SET rentalEndDate = @newEndDate
    WHERE Id = @rentalId;
END


---------------------------------------- Functions ----------------------------------------
GO
-- Function to calculate the total revenue for a given month
CREATE FUNCTION calculate_monthly_revenue
(
    @month INT,
    @year INT
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @revenue DECIMAL(10, 2);
    
    SELECT @revenue = SUM(totalCost)
    FROM [dbo].[Rental]
    WHERE MONTH(rentalStartDate) = @month AND YEAR(rentalStartDate) = @year;
    
    RETURN @revenue;
END
GO

-- Function to calculate the average rental duration
CREATE FUNCTION calculate_avg_rental_duration
(
)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @avgDuration DECIMAL(10, 2);
    
    SELECT @avgDuration = AVG(DATEDIFF(day, rentalStartDate, rentalEndDate) + 1)
    FROM [dbo].[Rental];
    
    RETURN @avgDuration;
END
GO


---------------------------------------- Sample data ----------------------------------------
-- Sample data - Customer
INSERT INTO [dbo].[Customer] ([Id], [name], [email], [phone])
VALUES (1, 'John Smith', 'john@example.com', '123-456-7890');

INSERT INTO [dbo].[Customer] ([Id], [name], [email], [phone])
VALUES (2, 'Alice Johnson', 'alice@example.com', '987-654-3210');

INSERT INTO [dbo].[Customer] ([Id], [name], [email], [phone])
VALUES (3, 'Michael Brown', 'michael@example.com', '456-123-7890');

INSERT INTO [dbo].[Customer] ([Id], [name], [email], [phone])
VALUES (4, 'Emily Davis', 'emily@example.com', '789-123-4560');

INSERT INTO [dbo].[Customer] ([Id], [name], [email], [phone])
VALUES (5, 'Daniel Wilson', 'daniel@example.com', '321-654-0987');

INSERT INTO [dbo].[Customer] ([Id], [name], [email], [phone])
VALUES (6, 'Sophia Thompson', 'sophia@example.com', '567-890-1234');

INSERT INTO [dbo].[Customer] ([Id], [name], [email], [phone])
VALUES (7, 'David Martinez', 'david@example.com', '908-765-4321');

INSERT INTO [dbo].[Customer] ([Id], [name], [email], [phone])
VALUES (8, 'Olivia Rodriguez', 'olivia@example.com', '234-567-8901');

INSERT INTO [dbo].[Customer] ([Id], [name], [email], [phone])
VALUES (9, 'James Harris', 'james@example.com', '678-901-2345');

INSERT INTO [dbo].[Customer] ([Id], [name], [email], [phone])
VALUES (10, 'Emma Clark', 'emma@example.com', '901-234-5678');

INSERT INTO [dbo].[Customer] ([Id], [name], [email], [phone])
VALUES (11, 'Alexander Lee', 'alexander@example.com', '345-678-9012');

INSERT INTO [dbo].[Customer] ([Id], [name], [email], [phone])
VALUES (12, 'Isabella Turner', 'isabella@example.com', '678-901-2345');

INSERT INTO [dbo].[Customer] ([Id], [name], [email], [phone])
VALUES (13, 'Liam Baker', 'liam@example.com', '123-456-7890');

INSERT INTO [dbo].[Customer] ([Id], [name], [email], [phone])
VALUES (14, 'Mia Ward', 'mia@example.com', '987-654-3210');

INSERT INTO [dbo].[Customer] ([Id], [name], [email], [phone])
VALUES (15, 'Ethan Cooper', 'ethan@example.com', '456-123-7890');

INSERT INTO [dbo].[Customer] ([Id], [name], [email], [phone])
VALUES (16, 'Charlotte Evans', 'charlotte@example.com', '789-123-4560');

INSERT INTO [dbo].[Customer] ([Id], [name], [email], [phone])
VALUES (17, 'Aiden Rivera', 'aiden@example.com', '321-654-0987');

INSERT INTO [dbo].[Customer] ([Id], [name], [email], [phone])
VALUES (18, 'Harper Ward', 'harper@example.com', '567-890-1234');

INSERT INTO [dbo].[Customer] ([Id], [name], [email], [phone])
VALUES (19, 'Benjamin Butler', 'benjamin@example.com', '908-765-4321');

INSERT INTO [dbo].[Customer] ([Id], [name], [email], [phone])
VALUES (20, 'Avery Powell', 'avery@example.com', '234-567-8901');

-- Sample data - Vehicle
INSERT INTO [dbo].[Vehicle] ([Id], [make], [model], [year], [plateNumber], [rentalRatePerDay], [status])
VALUES (1, 'Toyota', 'Camry', 2019, 'ABC123', 50.00, 'available');

INSERT INTO [dbo].[Vehicle] ([Id], [make], [model], [year], [plateNumber], [rentalRatePerDay], [status])
VALUES (2, 'Honda', 'Civic', 2020, 'DEF456', 45.00, 'available');

INSERT INTO [dbo].[Vehicle] ([Id], [make], [model], [year], [plateNumber], [rentalRatePerDay], [status])
VALUES (3, 'Ford', 'Mustang', 2022, 'GHI789', 70.00, 'available');

INSERT INTO [dbo].[Vehicle] ([Id], [make], [model], [year], [plateNumber], [rentalRatePerDay], [status])
VALUES (4, 'Chevrolet', 'Silverado', 2021, 'JKL012', 65.00, 'available');

INSERT INTO [dbo].[Vehicle] ([Id], [make], [model], [year], [plateNumber], [rentalRatePerDay], [status])
VALUES (5, 'BMW', 'X5', 2018, 'MNO345', 90.00, 'rented');

INSERT INTO [dbo].[Vehicle] ([Id], [make], [model], [year], [plateNumber], [rentalRatePerDay], [status])
VALUES (6, 'Mercedes-Benz', 'E-Class', 2020, 'PQR678', 80.00, 'rented');

INSERT INTO [dbo].[Vehicle] ([Id], [make], [model], [year], [plateNumber], [rentalRatePerDay], [status])
VALUES (7, 'Audi', 'A4', 2019, 'STU901', 75.00, 'rented');

INSERT INTO [dbo].[Vehicle] ([Id], [make], [model], [year], [plateNumber], [rentalRatePerDay], [status])
VALUES (8, 'Nissan', 'Altima', 2022, 'VWX234', 55.00, 'available');

INSERT INTO [dbo].[Vehicle] ([Id], [make], [model], [year], [plateNumber], [rentalRatePerDay], [status])
VALUES (9, 'Jeep', 'Wrangler', 2021, 'YZA567', 85.00, 'available');

INSERT INTO [dbo].[Vehicle] ([Id], [make], [model], [year], [plateNumber], [rentalRatePerDay], [status])
VALUES (10, 'Subaru', 'Outback', 2020, 'BCD890', 60.00, 'available');

INSERT INTO [dbo].[Vehicle] ([Id], [make], [model], [year], [plateNumber], [rentalRatePerDay], [status])
VALUES (11, 'Toyota', 'Rav4', 2019, 'EFG123', 55.00, 'available');

INSERT INTO [dbo].[Vehicle] ([Id], [make], [model], [year], [plateNumber], [rentalRatePerDay], [status])
VALUES (12, 'Honda', 'Accord', 2022, 'HIJ456', 65.00, 'available');

INSERT INTO [dbo].[Vehicle] ([Id], [make], [model], [year], [plateNumber], [rentalRatePerDay], [status])
VALUES (13, 'Ford', 'Explorer', 2021, 'KLM789', 75.00, 'available');

INSERT INTO [dbo].[Vehicle] ([Id], [make], [model], [year], [plateNumber], [rentalRatePerDay], [status])
VALUES (14, 'Chevrolet', 'Cruze', 2020, 'NOP012', 50.00, 'available');

INSERT INTO [dbo].[Vehicle] ([Id], [make], [model], [year], [plateNumber], [rentalRatePerDay], [status])
VALUES (15, 'BMW', '3 Series', 2018, 'QRS345', 85.00, 'rented');

INSERT INTO [dbo].[Vehicle] ([Id], [make], [model], [year], [plateNumber], [rentalRatePerDay], [status])
VALUES (16, 'Mercedes-Benz', 'GLC', 2021, 'TUV678', 90.00, 'rented');

INSERT INTO [dbo].[Vehicle] ([Id], [make], [model], [year], [plateNumber], [rentalRatePerDay], [status])
VALUES (17, 'Audi', 'Q5', 2020, 'WXY901', 80.00, 'rented');

INSERT INTO [dbo].[Vehicle] ([Id], [make], [model], [year], [plateNumber], [rentalRatePerDay], [status])
VALUES (18, 'Nissan', 'Maxima', 2019, 'ZAB234', 65.00, 'available');

INSERT INTO [dbo].[Vehicle] ([Id], [make], [model], [year], [plateNumber], [rentalRatePerDay], [status])
VALUES (19, 'Jeep', 'Grand Cherokee', 2022, 'BCD567', 95.00, 'available');

INSERT INTO [dbo].[Vehicle] ([Id], [make], [model], [year], [plateNumber], [rentalRatePerDay], [status])
VALUES (20, 'Subaru', 'Forester', 2021, 'EFG890', 70.00, 'available');

-- Sample data - Rental
INSERT INTO [dbo].[Rental] ([Id], [customerId], [vehicleId], [rentalStartDate], [rentalEndDate], [totalCost])
VALUES (1, 1, 1, '2023-01-01', '2023-01-05', 250.00);

INSERT INTO [dbo].[Rental] ([Id], [customerId], [vehicleId], [rentalStartDate], [rentalEndDate], [totalCost])
VALUES (2, 2, 3, '2023-02-10', '2023-02-15', 420.00);

INSERT INTO [dbo].[Rental] ([Id], [customerId], [vehicleId], [rentalStartDate], [rentalEndDate], [totalCost])
VALUES (3, 3, 5, '2023-03-20', '2023-03-25', 540.00);

INSERT INTO [dbo].[Rental] ([Id], [customerId], [vehicleId], [rentalStartDate], [rentalEndDate], [totalCost])
VALUES (4, 4, 7, '2023-04-05', '2023-04-12', 525.00);

INSERT INTO [dbo].[Rental] ([Id], [customerId], [vehicleId], [rentalStartDate], [rentalEndDate], [totalCost])
VALUES (5, 5, 9, '2023-05-15', '2023-05-20', 425.00);

INSERT INTO [dbo].[Rental] ([Id], [customerId], [vehicleId], [rentalStartDate], [rentalEndDate], [totalCost])
VALUES (6, 6, 11, '2023-06-10', '2023-06-15', 330.00);

INSERT INTO [dbo].[Rental] ([Id], [customerId], [vehicleId], [rentalStartDate], [rentalEndDate], [totalCost])
VALUES (7, 7, 13, '2023-07-01', '2023-07-07', 420.00);

INSERT INTO [dbo].[Rental] ([Id], [customerId], [vehicleId], [rentalStartDate], [rentalEndDate], [totalCost])
VALUES (8, 8, 15, '2023-08-05', '2023-08-12', 630.00);

INSERT INTO [dbo].[Rental] ([Id], [customerId], [vehicleId], [rentalStartDate], [rentalEndDate], [totalCost])
VALUES (9, 9, 17, '2023-09-15', '2023-09-20', 480.00);

INSERT INTO [dbo].[Rental] ([Id], [customerId], [vehicleId], [rentalStartDate], [rentalEndDate], [totalCost])
VALUES (10, 10, 19, '2023-10-10', '2023-10-15', 350.00);

INSERT INTO [dbo].[Rental] ([Id], [customerId], [vehicleId], [rentalStartDate], [rentalEndDate], [totalCost])
VALUES (11, 1, 2, '2023-01-10', '2023-01-15', 350.00);

INSERT INTO [dbo].[Rental] ([Id], [customerId], [vehicleId], [rentalStartDate], [rentalEndDate], [totalCost])
VALUES (12, 2, 4, '2023-02-20', '2023-02-25', 520.00);

INSERT INTO [dbo].[Rental] ([Id], [customerId], [vehicleId], [rentalStartDate], [rentalEndDate], [totalCost])
VALUES (13, 3, 6, '2023-03-05', '2023-03-12', 500.00);

INSERT INTO [dbo].[Rental] ([Id], [customerId], [vehicleId], [rentalStartDate], [rentalEndDate], [totalCost])
VALUES (14, 4, 8, '2023-04-15', '2023-04-20', 400.00);

INSERT INTO [dbo].[Rental] ([Id], [customerId], [vehicleId], [rentalStartDate], [rentalEndDate], [totalCost])
VALUES (15, 5, 10, '2023-05-10', '2023-05-15', 300.00);

INSERT INTO [dbo].[Rental] ([Id], [customerId], [vehicleId], [rentalStartDate], [rentalEndDate], [totalCost])
VALUES (16, 6, 12, '2023-06-20', '2023-06-25', 480.00);

INSERT INTO [dbo].[Rental] ([Id], [customerId], [vehicleId], [rentalStartDate], [rentalEndDate], [totalCost])
VALUES (17, 7, 14, '2023-07-05', '2023-07-12', 460.00);

INSERT INTO [dbo].[Rental] ([Id], [customerId], [vehicleId], [rentalStartDate], [rentalEndDate], [totalCost])
VALUES (18, 8, 16, '2023-08-15', '2023-08-20', 400.00);

INSERT INTO [dbo].[Rental] ([Id], [customerId], [vehicleId], [rentalStartDate], [rentalEndDate], [totalCost])
VALUES (19, 9, 18, '2023-09-10', '2023-09-15', 320.00);

INSERT INTO [dbo].[Rental] ([Id], [customerId], [vehicleId], [rentalStartDate], [rentalEndDate], [totalCost])
VALUES (20, 10, 20, '2023-10-20', '2023-10-25', 480.00);
