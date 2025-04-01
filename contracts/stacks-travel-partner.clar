;; Stacks Travel Partner - User profile management system for travelers
;; This contract stores and manages travel preferences and history

;; Data storage for traveler information indexed by their blockchain identity
(define-map traveler-data
    principal  ;; User's blockchain address
    {
        username: (string-ascii 100),              ;; Traveler's display name
        years: uint,                               ;; Traveler's current age
        hobbies: (list 10 (string-ascii 50)),      ;; Activities and topics the traveler enjoys
        bucket-list: (list 5 (string-ascii 100)),  ;; Places the traveler wants to visit
        visited-places: (list 5 (string-ascii 100)) ;; Places the traveler has already been to
    }
)

;; Error code definitions for better user feedback
(define-constant ERROR-NO-DATA-FOUND (err u404))        ;; Requested data doesn't exist
(define-constant ERROR-RECORD-EXISTS (err u409))        ;; Cannot create duplicate records
(define-constant ERROR-YEARS-INVALID (err u400))        ;; Age validation failed
(define-constant ERROR-USERNAME-INVALID (err u401))     ;; Name validation failed
(define-constant ERROR-LOCATION-INVALID (err u402))     ;; Destination validation failed
(define-constant ERROR-HOBBIES-INVALID (err u403))      ;; Interests validation failed
(define-constant ERROR-HISTORY-INVALID (err u404))      ;; Travel history validation failed

;; Read-only helper function - Check if a traveler profile exists
(define-read-only (does-profile-exist? (user-id principal))
    (match (map-get? traveler-data user-id)
        profile (ok true)  ;; Profile found
        (ok false)         ;; No profile found
    )
)

;; Read-only function - Get complete traveler profile
(define-read-only (fetch-traveler-profile (user-id principal))
    (match (map-get? traveler-data user-id)
        profile (ok profile)  ;; Return full profile data
        ERROR-NO-DATA-FOUND   ;; Profile not in database
    )
)

