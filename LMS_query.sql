--Library Management System:
CREATE TABLE Books (
    BookID INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-incrementing BookID as Primary Key
    Title NVARCHAR(255) NOT NULL,           -- Title of the book
    Author NVARCHAR(255) NOT NULL,          -- Author of the book
    ISBN VARCHAR(13) UNIQUE NOT NULL,       -- ISBN (assumed 13 characters format), unique constraint
    Genre NVARCHAR(100),                    -- Genre of the book
    PublicationDate DATE,                   -- Publication date
    AvailableCopies INT CHECK (AvailableCopies >= 0)  -- Available copies, must be 0 or greater
);
CREATE TABLE Members (
    MemberID INT IDENTITY(1,1) PRIMARY KEY,  -- Auto-incrementing MemberID as Primary Key
    Name NVARCHAR(255) NOT NULL,             -- Member's name
    ContactInfo NVARCHAR(255) NOT NULL,      -- Member's contact information
    MembershipType NVARCHAR(50) NOT NULL     -- Type of membership (e.g., Regular, Premium)
);
CREATE TABLE Loans (
    LoanID INT IDENTITY(1,1) PRIMARY KEY,   -- Auto-incrementing LoanID as Primary Key
    BookID INT,                              -- Foreign key referencing Books
    MemberID INT,                            -- Foreign key referencing Members
    LoanDate DATE NOT NULL,                  -- Date the book was loaned
    DueDate DATE NOT NULL,                   -- Due date for return
    ReturnDate DATE,                         -- Actual return date (can be NULL if not returned)
    CONSTRAINT FK_Book FOREIGN KEY (BookID) REFERENCES Books(BookID),  -- Foreign key constraint to Books
    CONSTRAINT FK_Member FOREIGN KEY (MemberID) REFERENCES Members(MemberID),  -- Foreign key constraint to Members
    CONSTRAINT CHK_LoanDate CHECK (LoanDate <= DueDate)  -- Ensure that loan date is not after the due date
);


-- Declare the search term variable
DECLARE @searchTerm NVARCHAR(255);
SET @searchTerm = 'YourSearchTerm';  -- Replace 'YourSearchTerm' with the desired value

-- Find available books by title or author
SELECT BookID, Title, Author, AvailableCopies
FROM Books
WHERE (Title LIKE '%' + @searchTerm + '%' OR Author LIKE '%' + @searchTerm + '%')
  AND AvailableCopies > 0;



 -- 2. Track Overdue Items
-- Track overdue items
SELECT L.LoanID, B.Title, M.Name AS MemberName, L.LoanDate, L.DueDate
FROM Loans L
JOIN Books B ON L.BookID = B.BookID
JOIN Members M ON L.MemberID = M.MemberID
WHERE L.ReturnDate IS NULL
  AND L.DueDate < GETDATE();  -- GETDATE() returns the current date and time



  --3. Generate Reports on Borrowing History by a Member
-- Declare the member ID variable
DECLARE @memberID INT;
SET @memberID = 123;  -- Replace 123 with the desired member's ID

-- Generate report on borrowing history by a member
SELECT B.Title, L.LoanDate, L.DueDate, L.ReturnDate
FROM Loans L
JOIN Books B ON L.BookID = B.BookID
WHERE L.MemberID = @memberID
ORDER BY L.LoanDate DESC;
