-- Users table
  CREATE TABLE Users (
    UserId STRING(36) NOT NULL,
    Email STRING(255) NOT NULL,
    Username STRING(100),
    FirstName STRING(100),
    LastName STRING(100),
    PasswordHash STRING(255),
    CreatedAt TIMESTAMP NOT NULL OPTIONS (allow_commit_timestamp=true),
    UpdatedAt TIMESTAMP OPTIONS (allow_commit_timestamp=true),
    LastLoginAt TIMESTAMP,
    Status STRING(20),
  ) PRIMARY KEY (UserId);

  -- Products table
  CREATE TABLE Products (
    ProductId STRING(36) NOT NULL,
    Name STRING(255) NOT NULL,
    Description STRING(MAX),
    Price NUMERIC NOT NULL,
    SKU STRING(50),
    InStock BOOL NOT NULL,
    Category STRING(100),
    CreatedAt TIMESTAMP NOT NULL OPTIONS (allow_commit_timestamp=true),
    UpdatedAt TIMESTAMP OPTIONS (allow_commit_timestamp=true),
  ) PRIMARY KEY (ProductId);

  -- Orders table
  CREATE TABLE Orders (
    OrderId STRING(36) NOT NULL,
    UserId STRING(36) NOT NULL,
    OrderDate TIMESTAMP NOT NULL OPTIONS (allow_commit_timestamp=true),
    Status STRING(20) NOT NULL,
    TotalAmount NUMERIC NOT NULL,
    ShippingAddress STRING(MAX),
    BillingAddress STRING(MAX),
    PaymentMethod STRING(50),
    FOREIGN KEY (UserId) REFERENCES Users (UserId),
  ) PRIMARY KEY (OrderId);

  -- Order Items table (interleaved in Orders)
  CREATE TABLE OrderItems (
    OrderId STRING(36) NOT NULL,
    ProductId STRING(36) NOT NULL,
    Quantity INT64 NOT NULL,
    UnitPrice NUMERIC NOT NULL,
    Subtotal NUMERIC NOT NULL,
    FOREIGN KEY (ProductId) REFERENCES Products (ProductId),
  ) PRIMARY KEY (OrderId, ProductId),
    INTERLEAVE IN PARENT Orders ON DELETE CASCADE;

  -- Create index on User Email (for lookups)
  CREATE UNIQUE INDEX UserEmailIndex ON Users(Email);

  -- Create index on Product Category (for filtering)
  CREATE INDEX ProductCategoryIndex ON Products(Category);

  -- Create index on Order Status (for filtering)
  CREATE INDEX OrderStatusIndex ON Orders(Status);