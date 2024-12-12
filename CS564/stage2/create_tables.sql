-- Create regions table
CREATE TABLE regions (
    region_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    region_name TEXT NOT NULL
);

-- Create countries table
CREATE TABLE countries (
    country_id TEXT PRIMARY KEY NOT NULL,
    country_name TEXT NOT NULL,
    region_id INTEGER NOT NULL,
    FOREIGN KEY (region_id) REFERENCES regions (region_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create locations table
CREATE TABLE locations (
    location_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    street_address TEXT,
    postal_code TEXT,
    city TEXT NOT NULL,
    state_province TEXT,
    country_id TEXT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES countries (country_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create departments table
CREATE TABLE departments (
    department_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    department_name TEXT NOT NULL,
    location_id INTEGER NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations (location_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create jobs table
CREATE TABLE jobs (
    job_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    job_title TEXT NOT NULL,
    min_salary REAL NOT NULL,
    max_salary REAL NOT NULL
);

-- Create employees table
CREATE TABLE employees (
    employee_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    first_name TEXT,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone_number TEXT,
    hire_date TEXT NOT NULL,
    job_id INTEGER NOT NULL,
    salary REAL NOT NULL,
    manager_id INTEGER,
    department_id INTEGER NOT NULL,
    FOREIGN KEY (job_id) REFERENCES jobs (job_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (department_id) REFERENCES departments (department_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (manager_id) REFERENCES employees (employee_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create dependents table
CREATE TABLE dependents (
    dependent_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    relationship TEXT NOT NULL,
    employee_id INTEGER NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees (employee_id) ON DELETE CASCADE ON UPDATE CASCADE
);

