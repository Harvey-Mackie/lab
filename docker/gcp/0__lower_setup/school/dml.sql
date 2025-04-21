-- Insert sample users
INSERT INTO Users (
  UserId, 
  Email, 
  Username, 
  FirstName, 
  LastName, 
  PasswordHash, 
  CreatedAt, 
  Status
) VALUES (
  "00000000-0000-0000-0000-000000000001", 
  "john.doe@example.com", 
  "johndoe", 
  "John", 
  "Doe", 
  "hashed_password_1", 
  CURRENT_TIMESTAMP(), 
  "ACTIVE"
);
