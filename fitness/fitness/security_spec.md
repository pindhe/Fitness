# Security Specification for FitPulse

## 1. Data Invariants
- A user can only access their own data (`/users/{userId}/**`).
- A user cannot change their own role to `admin`.
- `admin` role is verified against the `/admins/` collection.
- Timestamps must be server-side.
- All IDs must be valid strings.

## 2. The Dirty Dozen Payloads
1. **Identity Spoofing**: Attempt to create a user profile for another UID.
2. **Privilege Escalation**: Attempt to set `role: "admin"` during user creation.
3. **Privilege Escalation (Update)**: Attempt to update `role` from "user" to "admin".
4. **Data Theft**: Authenticated user trying to read another user's workout plans.
5. **Orphaned Write**: Creating a workout plan without a valid user profile.
6. **Value Poisoning**: Sending a 2MB string as an exercise name.
7. **Timestamp Spoofing**: Sending a past date for `createdAt`.
8. **Malicious ID**: Using a 500-character string as a `{planId}`.
9. **Admin Spoofing**: Attempting to write to `/admins/` as a normal user.
10. **State Corruption**: Deleting another user's workout history.
11. **Bulk Scraping**: Trying to list all users without being an admin.
12. **PII Leak**: Reading private user emails without being the owner or admin.

## 3. Test Runner
(This is a conceptual test runner for firestore.rules.test.ts)
- `test('Identity Spoofing', () => expect(writeOtherUser).toDeny())`
- `test('Privilege Escalation', () => expect(setAdminRole).toDeny())`
- `test('Data Theft', () => expect(readOtherPlans).toDeny())`
- ...and so on.
