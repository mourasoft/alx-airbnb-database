-- Enable UUID generation (PostgreSQL)
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ENUM types
CREATE TYPE user_role AS ENUM ('guest','host','admin');
CREATE TYPE booking_status AS ENUM ('pending','confirmed','canceled');
CREATE TYPE payment_method AS ENUM ('credit_card','paypal','stripe');

-- Drop tables in dependency order
DROP TABLE IF EXISTS property_amenity;
DROP TABLE IF EXISTS message;
DROP TABLE IF EXISTS review;
DROP TABLE IF EXISTS payment;
DROP TABLE IF EXISTS booking;
DROP TABLE IF EXISTS amenity;
DROP TABLE IF EXISTS property;
DROP TABLE IF EXISTS "user";

-- User
CREATE TABLE "user" (
  user_id        UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  first_name     VARCHAR(100) NOT NULL,
  last_name      VARCHAR(100) NOT NULL,
  email          VARCHAR(255) NOT NULL UNIQUE,
  password_hash  VARCHAR(255) NOT NULL,
  phone_number   VARCHAR(20),
  role           user_role NOT NULL,
  created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_user_email ON "user"(email);

-- Property
CREATE TABLE property (
  property_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  host_id         UUID NOT NULL REFERENCES "user"(user_id),
  name            VARCHAR(200) NOT NULL,
  description     TEXT NOT NULL,
  location        VARCHAR(255) NOT NULL,
  pricepernight   DECIMAL(10,2) NOT NULL,
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_property_host    ON property(host_id);
CREATE INDEX idx_property_location ON property(location);

-- Booking
CREATE TABLE booking (
  booking_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  property_id   UUID NOT NULL REFERENCES property(property_id),
  user_id       UUID NOT NULL REFERENCES "user"(user_id),
  start_date    DATE NOT NULL,
  end_date      DATE NOT NULL,
  total_price   DECIMAL(10,2) NOT NULL,
  status        booking_status NOT NULL,
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_booking_property ON booking(property_id);
CREATE INDEX idx_booking_user     ON booking(user_id);

-- Payment
CREATE TABLE payment (
  payment_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id     UUID NOT NULL REFERENCES booking(booking_id),
  amount         DECIMAL(10,2) NOT NULL,
  payment_date   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  payment_method payment_method NOT NULL
);
CREATE INDEX idx_payment_booking ON payment(booking_id);

-- Review
CREATE TABLE review (
  review_id     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  property_id   UUID NOT NULL REFERENCES property(property_id),
  user_id       UUID NOT NULL REFERENCES "user"(user_id),
  rating        INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment       TEXT NOT NULL,
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_review_property ON review(property_id);

-- Message
CREATE TABLE message (
  message_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sender_id     UUID NOT NULL REFERENCES "user"(user_id),
  recipient_id  UUID NOT NULL REFERENCES "user"(user_id),
  message_body  TEXT NOT NULL,
  sent_at       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_message_sender    ON message(sender_id);
CREATE INDEX idx_message_recipient ON message(recipient_id);

-- Amenity
CREATE TABLE amenity (
  amenity_id  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        VARCHAR(100) UNIQUE NOT NULL
);

-- Property ↔ Amenity
CREATE TABLE property_amenity (
  property_id UUID NOT NULL REFERENCES property(property_id),
  amenity_id  UUID NOT NULL REFERENCES amenity(amenity_id),
  PRIMARY KEY (property_id, amenity_id)
);
