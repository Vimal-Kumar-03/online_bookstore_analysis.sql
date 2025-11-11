-- Create Database

CREATE DATABASE OnlineBookstore;
-- Switch to the database
USE OnlineBookstore;


-- Create Tables
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- imported data already
-- 4️⃣ Queries

-- 1. Total revenue
SELECT SUM(Total_Amount) AS total_revenue 
FROM Orders;

-- 2. Total books sold
SELECT SUM(Quantity) AS total_books_sold 
FROM Orders;

-- 3. Average order value
SELECT AVG(Total_Amount) AS avg_order_value 
FROM Orders;

-- 4. Total revenue per customer
SELECT c.Name, SUM(o.Total_Amount) AS revenue
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Name
ORDER BY revenue DESC;

-- 5. Total revenue per book
SELECT b.Title, SUM(o.Total_Amount) AS revenue
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Title
ORDER BY revenue DESC;

-- 6. Total revenue per genre
SELECT b.Genre, SUM(o.Total_Amount) AS revenue
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Genre
ORDER BY revenue DESC;

-- 7. Number of orders per customer
SELECT c.Name, COUNT(o.Order_ID) AS order_count
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Name
ORDER BY order_count DESC;

-- 8. Top customers by revenue
SELECT c.Name, SUM(o.Total_Amount) AS total_spent
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Name
ORDER BY total_spent DESC
LIMIT 5;

-- 9. Customers who bought more than 5 books
SELECT c.Name, SUM(o.Quantity) AS total_books
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Name
HAVING SUM(o.Quantity) > 5;

-- 10. Customer distribution by city
SELECT City, COUNT(Customer_ID) AS num_customers
FROM Customers
GROUP BY City
ORDER BY num_customers DESC;

-- 11. Customer distribution by country
SELECT Country, COUNT(Customer_ID) AS num_customers
FROM Customers
GROUP BY Country
ORDER BY num_customers DESC;

-- 12. Books with the lowest stock
SELECT Title, Stock FROM Books ORDER BY Stock ASC LIMIT 5;

-- 13. Books with highest stock sold
SELECT b.Title, SUM(o.Quantity) AS total_sold
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Title
ORDER BY total_sold DESC LIMIT 5;

-- 14. Total stock remaining per book
SELECT b.Title, b.Stock - COALESCE(SUM(o.Quantity),0) AS remaining_stock
FROM Books b
LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Title, b.Stock
ORDER BY remaining_stock ASC;

-- 15. Out-of-stock books
SELECT Title FROM Books WHERE Stock = 0;

-- 16. Books never ordered
SELECT b.Title
FROM Books b
LEFT JOIN Orders o ON b.Book_ID = o.Book_ID
WHERE o.Order_ID IS NULL;

-- 17. Orders per month
SELECT MONTH(Order_Date) AS month, COUNT(Order_ID) AS num_orders
FROM Orders
GROUP BY month
ORDER BY month;

-- 18. Orders per year
SELECT YEAR(Order_Date) AS year, COUNT(Order_ID) AS num_orders
FROM Orders
GROUP BY year
ORDER BY year;

-- 19. Most frequently ordered book
SELECT b.Title, COUNT(o.Order_ID) AS order_count
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Title
ORDER BY order_count DESC
LIMIT 1;

-- 20. Least frequently ordered book
SELECT b.Title, COUNT(o.Order_ID) AS order_count
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Title
ORDER BY order_count ASC
LIMIT 1;

-- 21. Orders exceeding $50
SELECT * FROM Orders 
WHERE Total_Amount > 50 
ORDER BY Total_Amount DESC;

-- 22. Average quantity per order
SELECT AVG(Quantity) AS avg_quantity FROM Orders;

-- 23. Total books sold per genre
SELECT b.Genre, SUM(o.Quantity) AS total_sold
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Genre
ORDER BY total_sold DESC;

-- 24. Total revenue per month
SELECT MONTH(Order_Date) AS month, SUM(Total_Amount) AS revenue
FROM Orders
GROUP BY month
ORDER BY month;

-- 25. Top 5 best-selling books
SELECT b.Title, SUM(o.Quantity) AS total_sold
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Title
ORDER BY total_sold DESC
LIMIT 5;
