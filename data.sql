-- Drop and create the database
DROP DATABASE IF EXISTS data;
CREATE DATABASE data;
USE data;

-- Drop tables if they exist (in reverse dependency order)
DROP TABLE IF EXISTS invoice_items;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS tracks;
DROP TABLE IF EXISTS albums;
DROP TABLE IF EXISTS artists;

-- Create artists table
CREATE TABLE artists (
    ArtistId INT PRIMARY KEY,
    Name VARCHAR(100)
);

-- Create albums table
CREATE TABLE albums (
    AlbumId INT PRIMARY KEY,
    Title VARCHAR(200),
    ArtistId INT,
    FOREIGN KEY (ArtistId) REFERENCES artists(ArtistId)
);

-- Create tracks table
CREATE TABLE tracks (
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
CREATE TABLE customers (
    CustomerId INT PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(100),
    Country VARCHAR(100)
);

-- Create invoices table
CREATE TABLE invoices (
    InvoiceId INT PRIMARY KEY,
    CustomerId INT,
    InvoiceDate DATE,
    BillingCountry VARCHAR(100),
    FOREIGN KEY (CustomerId) REFERENCES customers(CustomerId)
);

-- Create invoice_items table
CREATE TABLE invoice_items (
    InvoiceLineId INT PRIMARY KEY,
    InvoiceId INT,
    TrackId INT,
    UnitPrice DECIMAL(5,2),
    Quantity INT,
    FOREIGN KEY (InvoiceId) REFERENCES invoices(InvoiceId),
    FOREIGN KEY (TrackId) REFERENCES tracks(TrackId)
);

-- Insert into artists
INSERT INTO artists (ArtistId, Name) VALUES
(1, 'AC/DC'),
(2, 'Accept'),
(3, 'Aerosmith');

-- Insert into albums
INSERT INTO albums (AlbumId, Title, ArtistId) VALUES
(1, 'For Those About To Rock We Salute You', 1),
(2, 'Balls to the Wall', 2),
(3, 'Big Ones', 3);

-- Insert into tracks
INSERT INTO tracks (TrackId, Name, AlbumId, MediaTypeId, GenreId, Milliseconds, UnitPrice) VALUES
(1, 'For Those About To Rock (We Salute You)', 1, 1, 1, 343719, 0.99),
(2, 'Put The Finger On You', 1, 1, 1, 205662, 0.99),
(3, 'Balls to the Wall', 2, 1, 1, 342562, 0.99),
(4, 'Fast As A Shark', 2, 1, 1, 230000, 0.99),
(5, 'Angel', 3, 1, 2, 208694, 0.99),
(6, 'Rag Doll', 3, 1, 2, 254453, 0.99);

-- Insert into customers
INSERT INTO customers (CustomerId, FirstName, LastName, Email, Country) VALUES
(1, 'Luís', 'Gonçalves', 'luis@gmail.com', 'Brazil'),
(2, 'Leonie', 'Köhler', 'leonie@yahoo.com', 'Germany'),
(3, 'François', 'Tremblay', 'francois@hotmail.com', 'Canada');

-- Insert into invoices
INSERT INTO invoices (InvoiceId, CustomerId, InvoiceDate, BillingCountry) VALUES
(1, 1, '2025-01-01', 'Brazil'),
(2, 1, '2025-02-15', 'Brazil'),
(3, 2, '2025-03-10', 'Germany'),
(4, 3, '2025-04-05', 'Canada');

-- Insert into invoice_items
INSERT INTO invoice_items (InvoiceLineId, InvoiceId, TrackId, UnitPrice, Quantity) VALUES
(1, 1, 1, 0.99, 1),
(2, 1, 3, 0.99, 2),
(3, 2, 5, 0.99, 1),
(4, 2, 2, 0.99, 3),
(5, 3, 4, 0.99, 1),
(6, 4, 6, 0.99, 2);
