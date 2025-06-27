 Time-Locked Token Vault

A secure Clarity smart contract for locking STX tokens until a specified future block height on the [Stacks blockchain](https://www.stacks.co/). Useful for implementing token vesting, delayed payouts, or milestone-based trust systems.

---

 Overview

The `Time-Locked Token Vault` allows users to deposit STX that can only be withdrawn after a defined lock period. Each lock is tracked by a unique ID and associated with the depositor.

---

 Features

-  **Time-Locked Deposits**  
  Lock tokens until a future block height. Cannot be accessed until unlocked.

-  **Multiple Locks Per User**  
  Users can maintain multiple simultaneous token locks.

-  **Scheduled Release**  
  Tokens can only be withdrawn after the unlock height is reached.

-  **Read-Only Views**  
  Check unlock status, pending locks, and lock details.

-  **Error Handling**  
  Fails gracefully on early withdrawal or unauthorized access.

---

 Use Cases

- 🪙 **Token Vesting for Team or Investors**  
  Lock allocations that unlock gradually or after a cliff.

 **Deferred Payouts**  
  Ensure milestone rewards are only claimable after a date.

 **Trustless Fund Holding**  
  Secure STX without needing a third-party escrow.

---

 Contract Functions

 Lock STX Tokens
```clarity
(define-public (lock-tokens (unlock-height uint) (amount uint)) : (response uint uint))
