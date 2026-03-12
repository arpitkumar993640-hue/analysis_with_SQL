-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
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

--Q1 Retrive all books in the "Fiction" genre--
SELECT * FROM Books
where Genre='Fiction';
--Q2 find books publised after the year 1950--
select *from Books
where  Published_Year>1950;
--Q3 List all customer from the canada--
select *from customers 
where  Country='Canada'; 
--Q5 Show orders placed in November 2023--
select *from  Orders
where Order_Date between '2023-11-01'and '2023-11-30';
--Q6 Retrive the total stock of books availble--
select sum(Stock) from books as total_stock;
--7) Show all customers who ordered more than 1 quantity of a book--
select *from orders 
where    Quantity>1;
--8) Retrieve all orders where the total amount exceeds $20--
select *from books
where price>20;
--9) List all genres available in the Books table--
select distinct genre from books;
--10) Find the book with the lowest stock--
select *from books order by stock asc limit 1;
--11) Calculate the total revenue generated from all orders--
select sum( Total_Amount)as total_revenue from orders ;
/* ADVANCED QUERY*/
--1) Retrieve the total number of books sold for each genre--
select b.genre,sum(o.quantity)as total_booksold 
from orders o
join books b on b.book_id=o.book_id
group by b.genre;
--2) Find the average price of books in the "Fantasy" genre
select avg(price) as avg_price
from books
where genre='Fantasy';
--3) List customers who have placed at least 2 orders
select o.customer_id,c.name,COUNT(o.order_id) as order_count
from orders o
join customers c on c.Customer_ID=o.Customer_ID
group by o.customer_id,c.name
having count(order_id) >=2;
--4) Find the most frequently ordered book
select o.book_id,b.title ,count(o.order_id)as ordercount
from orders o
join books b on o.book_id=b.book_id
group by o.book_id,b.title
order by ordercount desc limit 1;
--5) Show the top 3 most expensive books of 'Fantasy' Genre
select *from books
where genre ='Fantasy'
order by price desc limit 3;
--6) Retrieve the total quantity of books sold by each author
select b.author,sum(o.quantity) as total_booksold
from orders o
join books b on o.book_id=b.book_id
group by b.author;
--7) List the cities where customers who spent over $30 are located
select distinct c.city,total_amount
from orders o
join customers c on c.customer_id=o.customer_id
where o.total_amount>30;
--8) Find the customer who spent the most on orders
select c.customer_id,c.city,c.name,sum(o.total_amount)as total_spent
from orders o
join customers c on c.customer_id=o.customer_id
group by c.customer_id,c.name,c.city
order by total_spent desc limit 1;
--9) Calculate the stock remaining after fulfilling all orders
select b.book_id,b.title,b.stock,coalesce(sum(quantity),0)as order_quantity
from books b 
left join orders o on b.book_id=o.book_id
group by b.book_id;