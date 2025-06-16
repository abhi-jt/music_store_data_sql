-- Create Tables

CREATE TABLE artists (
  ArtistId INTEGER PRIMARY KEY,
  Name TEXT
);

CREATE TABLE albums (
  AlbumId INTEGER PRIMARY KEY,
  Title TEXT,
  ArtistId INTEGER,
  FOREIGN KEY (ArtistId) REFERENCES artists(ArtistId)
);

CREATE TABLE tracks (
  TrackId INTEGER PRIMARY KEY,
  Name TEXT,
  AlbumId INTEGER,
  MediaTypeId INTEGER,
  GenreId INTEGER,
  Milliseconds INTEGER,
  UnitPrice REAL,
  FOREIGN KEY (AlbumId) REFERENCES albums(AlbumId)
);

CREATE TABLE customers (
  CustomerId INTEGER PRIMARY KEY,
  FirstName TEXT,
  LastName TEXT,
  Email TEXT,
  Country TEXT
);

CREATE TABLE invoices (
  InvoiceId INTEGER PRIMARY KEY,
  CustomerId INTEGER,
  InvoiceDate DATE,
  BillingCountry TEXT,
  FOREIGN KEY (CustomerId) REFERENCES customers(CustomerId)
);

CREATE TABLE invoice_items (
  InvoiceLineId INTEGER PRIMARY KEY,
  InvoiceId INTEGER,
  TrackId INTEGER,
  UnitPrice REAL,
  Quantity INTEGER,
  FOREIGN KEY (InvoiceId) REFERENCES invoices(InvoiceId),
  FOREIGN KEY (TrackId) REFERENCES tracks(TrackId)
);

-- Queries

-- 1. Top 5 best-selling tracks (by quantity)
SELECT t.Name AS track, SUM(ii.Quantity) AS total_sold
FROM invoice_items ii
JOIN tracks t ON ii.TrackId = t.TrackId
GROUP BY t.TrackId, t.Name
ORDER BY total_sold DESC
LIMIT 5;

-- 2. Revenue by artist
SELECT ar.Name AS artist, ROUND(SUM(ii.UnitPrice * ii.Quantity),2) AS revenue
FROM invoice_items ii
JOIN tracks t ON ii.TrackId = t.TrackId
JOIN albums al ON t.AlbumId = al.AlbumId
JOIN artists ar ON al.ArtistId = ar.ArtistId
GROUP BY ar.ArtistId, ar.Name
ORDER BY revenue DESC;

-- 3. Total spent per customer
SELECT c.FirstName || ' ' || c.LastName AS customer,
ROUND(SUM(ii.UnitPrice * ii.Quantity),2) AS total_spent
FROM invoice_items ii
JOIN invoices i ON ii.InvoiceId = i.InvoiceId
JOIN customers c ON i.CustomerId = c.CustomerId
GROUP BY c.CustomerId
ORDER BY total_spent DESC;

-- 4. Sales by country
SELECT i.BillingCountry AS country, COUNT(DISTINCT i.InvoiceId) AS invoices, ROUND(SUM(ii.UnitPrice * ii.Quantity),2) AS revenue
FROM invoices i
JOIN invoice_items ii ON i.InvoiceId = ii.InvoiceId
GROUP BY i.BillingCountry
ORDER BY revenue DESC;

-- 5. Tracks never sold
SELECT t.Name
FROM tracks t
LEFT JOIN invoice_items ii ON t.TrackId = ii.TrackId
WHERE ii.InvoiceLineId IS NULL;
