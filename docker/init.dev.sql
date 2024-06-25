-- Grant global privileges to the 'rails' user in development environment
GRANT ALL PRIVILEGES ON *.* TO 'rails'@'%';

-- Flush privileges to apply changes
FLUSH PRIVILEGES;
