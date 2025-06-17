-- Create and use the database
CREATE DATABASE IF NOT EXISTS data;
USE data;

-- Create artists table
CREATE TABLE IF NOT EXISTS artists (
  ArtistId INT PRIMARY KEY,
  Name VARCHAR(100)
);

-- Create albums table
CREATE TABLE IF NOT EXISTS albums (
  AlbumId INT PRIMARY KEY,
  Title VARCHAR(200),
  ArtistId INT,
  FOREIGN KEY (ArtistId) REFERENCES artists(ArtistId)
);

-- Create tracks table
CREATE TABLE IF NOT EXISTS tracks (
  TrackId INT PRIMARY KEY,
  Name VARCHAR(200),
  AlbumId INT,
  MediaTypeId INT,
  GenreId INT,
  Milliseconds INT,
  UnitPrice DECIMAL(5,2),
  FOREIGN KEY (AlbumId) REFERENCES albums(AlbumId)
);

-- Create customers table
CREATE TABLE IF NOT EXISTS customers (
  CustomerId INT PRIMARY KEY,
  FirstName VARCHAR(100),
  LastName VARCHAR(100),
  Email VARCHAR(100),
  Country VARCHAR(100)
);

-- Create invoices table
CREATE TABLE IF NOT EXISTS invoices (
  InvoiceId INT PRIMARY KEY,
  CustomerId INT,
  InvoiceDate DATE,
  BillingCountry VARCHAR(100),
  FOREIGN KEY (CustomerId) REFERENCES customers(CustomerId)
);

-- Create invoice_items table
CREATE TABLE IF NOT EXISTS invoice_items (
  InvoiceLineId INT PRIMARY KEY,
  InvoiceId INT,
  TrackId INT,
  UnitPrice DECIMAL(5,2),
  Quantity INT,
  FOREIGN KEY (InvoiceId) REFERENCES invoices(InvoiceId),
  FOREIGN KEY (TrackId) REFERENCES tracks(TrackId)
);



-- 1. Top 5 best-selling tracks (by quantity)
SELECT t.Name AS Track, SUM(ii.Quantity) AS Total_Sold
FROM invoice_items ii
JOIN tracks t ON ii.TrackId = t.TrackId
GROUP BY t.TrackId, t.Name
ORDER BY Total_Sold DESC
LIMIT 5;

-- 2. Revenue by artist
SELECT ar.Name AS Artist, ROUND(SUM(ii.UnitPrice * ii.Quantity), 2) AS Revenue
FROM invoice_items ii
JOIN tracks t ON ii.TrackId = t.TrackId
JOIN albums al ON t.AlbumId = al.AlbumId
JOIN artists ar ON al.ArtistId = ar.ArtistId
GROUP BY ar.ArtistId, ar.Name
ORDER BY Revenue DESC;

-- 3. Total spent per customer
SELECT CONCAT(c.FirstName, ' ', c.LastName) AS Customer,
ROUND(SUM(ii.UnitPrice * ii.Quantity), 2) AS Total_Spent
FROM invoice_items ii
JOIN invoices i ON ii.InvoiceId = i.InvoiceId
JOIN customers c ON i.CustomerId = c.CustomerId
GROUP BY c.CustomerId
ORDER BY Total_Spent DESC;

-- 4. Sales by country
SELECT i.BillingCountry AS Country,
COUNT(DISTINCT i.InvoiceId) AS Invoices,
ROUND(SUM(ii.UnitPrice * ii.Quantity), 2) AS Revenue
FROM invoices i
JOIN invoice_items ii ON i.InvoiceId = ii.InvoiceId
GROUP BY i.BillingCountry
ORDER BY Revenue DESC;

-- 5. Tracks never sold
SELECT t.Name AS Unsold_Track
FROM tracks t
LEFT JOIN invoice_items ii ON t.TrackId = ii.TrackId
WHERE ii.TrackId IS NULL;
