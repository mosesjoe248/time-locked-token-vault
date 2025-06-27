;; --------------------------------------------------
;; Contract: time-locked-token-vault
;; Description: Lock STX until a future block height
;; Author: [Your Name]
;; --------------------------------------------------

(define-constant ERR_NOT_OWNER (err u401))
(define-constant ERR_TOO_EARLY (err u402))
(define-constant ERR_NO_VAULT (err u403))
(define-constant ERR_ALREADY_LOCKED (err u404))

(define-map vaults
  { user: principal }
  {
    amount: uint,
    unlock-block: uint,
    beneficiary: principal
  }
)

;; === Deposit STX into a time-locked vault ===
(define-public (deposit-lock (amount uint) (unlock-block uint) (beneficiary principal))
  (begin
    ;; ensure no existing vault
    (asserts! (is-none (map-get? vaults {user: tx-sender})) ERR_ALREADY_LOCKED)

    ;; transfer STX to contract
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))

    ;; record lock
    (map-set vaults {user: tx-sender}
      {
        amount: amount,
        unlock-block: unlock-block,
        beneficiary: beneficiary
      }
    )
    (ok true)
  )
)

;; === Withdraw STX after lock period ===
(define-public (withdraw)
  (let ((vault (map-get? vaults {user: tx-sender})))
    (match vault
      vault-data (begin
          (asserts! (>= stacks-block-height (get unlock-block vault-data)) ERR_TOO_EARLY)
          (asserts! (is-eq tx-sender (get beneficiary vault-data)) ERR_NOT_OWNER)

          ;; transfer funds to beneficiary
          (try! (stx-transfer? (get amount vault-data) (as-contract tx-sender) tx-sender))

          ;; delete vault
          (map-delete vaults {user: tx-sender})

          (ok (get amount vault-data))
        )
      ERR_NO_VAULT)
  )
)

;; === View vault info for a user ===
(define-read-only (view-lock (user principal))
  (ok (map-get? vaults {user: user}))
)
