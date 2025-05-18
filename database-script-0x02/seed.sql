-- Users
INSERT INTO "user" (first_name, last_name, email, password_hash, phone_number, role) VALUES
  ('Alice','Dupont','alice.dupont@example.com','$2b$12$...','+212600000001','guest'),
  ('Omar','Ben','omar.ben@example.com','$2b$12$...','+212600000002','host'),
  ('Fatima','Zahra','fatima.zahra@example.com','$2b$12$...','+212600000003','host');

-- Properties
INSERT INTO property (host_id, name, description, location, pricepernight) VALUES
  ((SELECT user_id FROM "user" WHERE email='omar.ben@example.com'),
   'Cozy Casablanca Apt','Bright 1-br apt in city center','Casablanca',75.00),
  ((SELECT user_id FROM "user" WHERE email='fatima.zahra@example.com'),
   'Riad in Marrakech','Traditional riad with pool','Marrakech',120.00);

-- Bookings
INSERT INTO booking (property_id, user_id, start_date, end_date, total_price, status) VALUES
  ((SELECT property_id FROM property WHERE name='Cozy Casablanca Apt'),
   (SELECT user_id FROM "user" WHERE email='alice.dupont@example.com'),
   '2025-06-01','2025-06-05',300.00,'confirmed'),
  ((SELECT property_id FROM property WHERE name='Riad in Marrakech'),
   (SELECT user_id FROM "user" WHERE email='alice.dupont@example.com'),
   '2025-07-10','2025-07-12',360.00,'pending');

-- Payments
INSERT INTO payment (booking_id, amount, payment_method) VALUES
  ((SELECT booking_id FROM booking WHERE status='confirmed'),300.00,'credit_card');

-- Reviews
INSERT INTO review (property_id, user_id, rating, comment) VALUES
  ((SELECT property_id FROM property WHERE name='Cozy Casablanca Apt'),
   (SELECT user_id FROM "user" WHERE email='alice.dupont@example.com'),
   5,'Excellent location and very clean!');

-- Messages
INSERT INTO message (sender_id, recipient_id, message_body) VALUES
  ((SELECT user_id FROM "user" WHERE email='alice.dupont@example.com'),
   (SELECT user_id FROM "user" WHERE email='omar.ben@example.com'),
   'Hi Omar, is the apartment available early June?');

-- Amenities & links
INSERT INTO amenity (name) VALUES ('Wi-Fi'),('Pool'),('Kitchen');
INSERT INTO property_amenity (property_id, amenity_id)
SELECT p.property_id, a.amenity_id
FROM property p, amenity a
WHERE (p.name='Cozy Casablanca Apt' AND a.name IN ('Wi-Fi','Kitchen'))
   OR (p.name='Riad in Marrakech'   AND a.name IN ('Wi-Fi','Pool','Kitchen'));
