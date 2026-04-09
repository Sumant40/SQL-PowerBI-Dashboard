CREATE TABLE public.superstore (
    "Row ID" INT,
    "Order ID" TEXT,
    "Order Date" DATE,
    "Ship Date" DATE,
    "Ship Mode" TEXT,
    "Customer ID" TEXT,
    "Customer Name" TEXT,
    "Segment" TEXT,
    "Country" TEXT,
    "City" TEXT,
    "State" TEXT,
    "Postal Code" TEXT,
    "Region" TEXT,
    "Product ID" TEXT,
    "Category" TEXT,
    "Sub-Category" TEXT,
    "Product Name" TEXT,
    "Sales" FLOAT,
    "Quantity" INT,
    "Discount" FLOAT,
    "Profit" FLOAT
);

ALTER DATABASE "SQL project" SET datestyle TO 'ISO, MDY';