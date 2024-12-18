---
title: "Configurable Number of Iterations for PBKDF2 Password Storage Schemes"
---

# Configurable Number of Iterations for PBKDF2 Password Storage Schemes

## Overview
This design document describes the implementation of configurable number of iteration (rounds) for PBKDF2 password hashing schemes in 389 Directory Server. The feature adds the ability to customize the computational cost of password hashing through a new attribute `nsslapd-pwdPBKDF2NumIterations` and associated configuration mechanisms.

## Background
PBKDF2 (Password-Based Key Derivation Function 2) is a key stretching algorithm that makes password hashing more resistant to brute-force attacks by applying a cryptographic hash function repeatedly. The number of iterations directly affects the computational cost and security level of the password hashing process. As computing power increases over time, the ability to adjust iteration counts becomes crucial for maintaining security against evolving threats.

## Technical Design

### Schema Changes
1. **New Attribute**:
   ```ldif
   attributeTypes: ( 2.16.840.1.113730.3.1.2400
       NAME 'nsslapd-pwdPBKDF2NumIterations'
       DESC '389 Directory Server defined attribute type'
       SYNTAX 1.3.6.1.4.1.1466.115.121.1.27
       SINGLE-VALUE )
   ```

2. **New ObjectClass**:
   ```ldif
   objectClasses: ( 2.16.840.1.113730.3.2.340
       NAME 'pwdPBKDF2PluginConfig'
       DESC 'PBKDF2 Password Storage Plugin configuration'
       SUP top
       MAY ( nsslapd-pwdPBKDF2NumIterations ) )
   ```

### Implementation Details

#### Default and Limits
- **Default Iterations by Algorithm**:
  - PBKDF2-SHA1: 70,000 (fastest, needs more iterations)
  - PBKDF2-SHA256: 30,000 (balanced)
  - PBKDF2-SHA512: 10,000 (slowest, fewer iterations needed)
- **Minimum Iterations**: 10,000  
- **Maximum Iterations**: 10,000,000

These defaults and limits ensure a baseline security level and guard against extreme performance degradation.

#### Rust Implementation
- **Atomic Storage**:
  ```rust
  static PBKDF2_ROUNDS: AtomicUsize = AtomicUsize::new(DEFAULT_PBKDF2_SHA1_ROUNDS);
  static PBKDF2_ROUNDS_SHA1: AtomicUsize = AtomicUsize::new(DEFAULT_PBKDF2_SHA1_ROUNDS);
  static PBKDF2_ROUNDS_SHA256: AtomicUsize = AtomicUsize::new(DEFAULT_PBKDF2_SHA256_ROUNDS);
  static PBKDF2_ROUNDS_SHA512: AtomicUsize = AtomicUsize::new(DEFAULT_PBKDF2_SHA512_ROUNDS);
  ```

  Each variant (SHA-1, SHA-256, SHA-512) can have its iteration count stored atomically for thread-safe access.

- **Configuration Management**:
  ```rust
  fn handle_pbkdf2_rounds_config(pb: &mut PblockRef, digest: MessageDigest) -> Result<(), PluginError> {
      // Read configuration from the directory entry
      // Validate and store the new iteration value with set_pbkdf2_rounds() call
      // Log configuration changes
  }
  ```

- **Rounds Validation and Storage**:
  ```rust
  fn set_pbkdf2_rounds(digest: MessageDigest, rounds: usize) -> Result<(), PluginError> {
      if rounds < MIN_PBKDF2_ROUNDS || rounds > MAX_PBKDF2_ROUNDS {
          return Err(PluginError::InvalidConfiguration);
      }
      Self::get_rounds_atomic(digest).store(rounds, Ordering::Relaxed);
      Ok(())
  }
  ```

- **Password Hashing Integration**:
  ```rust
  fn pbkdf2_encrypt(cleartext: &str, digest: MessageDigest) -> Result<String, PluginError> {
      let rounds = Self::get_pbkdf2_rounds(digest)?;
      // The rest of the encryption code
  }
  ```

### Configuration Management
- **CLI Interface (dsconf)**:
  ```bash
  dsconf instance plugin pwstorage-scheme pbkdf2-sha512 get-num-iterations
  dsconf instance plugin pwstorage-scheme pbkdf2-sha256 set-num-iterations 15000
  dsctl instance restart  # Changes take effect after restart
  ```
- **Web UI**:
  A new option in the Web UI (Database -> Password Policies -> Global Policy) allows administrators to view and set the iteration count.

## Testing Plan
- **Functional Testing in Rust Code**:
   - Password hash generation with different iteration counts
   - Verification of existing password hashes
   - Boundary testing of iteration limits

- **Integration Testing**:
   - Configuration persistence across restarts
   - Plugin behavior with different storage schemes
   - CLI and UI functionality verification

## Conclusion
The ability to configure PBKDF2 iteration counts enhances the overall security posture of the 389 Directory Server by allowing administrators to scale password hashing complexity in line with evolving computational capabilities.
