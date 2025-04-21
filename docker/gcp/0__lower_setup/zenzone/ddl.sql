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

  -- Routines table
  CREATE TABLE Routines (
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
