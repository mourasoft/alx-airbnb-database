# Schema Definition

- **UUID PKs:** `gen_random_uuid()` for global uniqueness.
- **ENUMs:** `user_role`, `booking_status`, `payment_method`.
- **Indexes:** on email, foreign keys, and message lookups.
- **Timestamps:** default `CURRENT_TIMESTAMP`; `updated_at` auto-updated via trigger or application logic.
