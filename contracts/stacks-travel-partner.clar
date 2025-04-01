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



;; Read-only function - Get traveler's display name
(define-read-only (fetch-traveler-name (user-id principal))
    (match (map-get? traveler-data user-id)
        profile (ok (get username profile))  ;; Extract just the name
        ERROR-NO-DATA-FOUND                 ;; Profile not in database
    )
)

;; Read-only function - Get traveler's age
(define-read-only (fetch-traveler-age (user-id principal))
    (match (map-get? traveler-data user-id)
        profile (ok (get years profile))    ;; Extract just the age
        ERROR-NO-DATA-FOUND                ;; Profile not in database
    )
)

;; Read-only function - Get traveler's activity interests
(define-read-only (fetch-traveler-hobbies (user-id principal))
    (match (map-get? traveler-data user-id)
        profile (ok (get hobbies profile))  ;; Extract just the hobbies
        ERROR-NO-DATA-FOUND                ;; Profile not in database
    )
)

;; Read-only function - Get places traveler wants to visit
(define-read-only (fetch-bucket-list (user-id principal))
    (match (map-get? traveler-data user-id)
        profile (ok (get bucket-list profile))  ;; Extract just the bucket list
        ERROR-NO-DATA-FOUND                    ;; Profile not in database
    )
)

;; Read-only function - Get places traveler has visited
(define-read-only (fetch-visited-places (user-id principal))
    (match (map-get? traveler-data user-id)
        profile (ok (get visited-places profile))  ;; Extract just the travel history
        ERROR-NO-DATA-FOUND                       ;; Profile not in database
    )
)

;; Read-only function - Get count of bucket list destinations
(define-read-only (count-bucket-list-items (user-id principal))
    (match (map-get? traveler-data user-id)
        profile (ok (len (get bucket-list profile)))  ;; Count bucket list items
        ERROR-NO-DATA-FOUND                          ;; Profile not in database
    )
)

;; Read-only function - Get count of visited places
(define-read-only (count-visited-places (user-id principal))
    (match (map-get? traveler-data user-id)
        profile (ok (len (get visited-places profile)))  ;; Count visited places
        ERROR-NO-DATA-FOUND                             ;; Profile not in database
    )
)

;; Read-only function - Get summary of traveler profile statistics
(define-read-only (fetch-profile-stats (user-id principal))
    (match (map-get? traveler-data user-id)
        profile (ok {
            username: (get username profile),
            years: (get years profile),
            hobbies-count: (len (get hobbies profile)),
            bucket-list-count: (len (get bucket-list profile)),
            visited-places-count: (len (get visited-places profile))
        })  ;; Return consolidated profile statistics
        ERROR-NO-DATA-FOUND  ;; Profile not in database
    )
)

;; Public function - Create a new traveler profile
(define-public (create-traveler 
    (username (string-ascii 100))
    (years uint)
    (hobbies (list 10 (string-ascii 50)))
    (bucket-list (list 5 (string-ascii 100)))
    (visited-places (list 5 (string-ascii 100))))
    (let
        (
            (user-id tx-sender)  ;; Current user's blockchain address
            (existing-data (map-get? traveler-data user-id))  ;; Check if profile already exists
        )
        ;; First check if profile already exists
        (if (is-none existing-data)
            (begin
                ;; Validate all input parameters
                (if (or (is-eq username "")
                        (< years u18)                   ;; Must be adult
                        (> years u120)                  ;; Reasonable upper limit
                        (is-eq (len bucket-list) u0)    ;; Must have travel goals
                        (is-eq (len hobbies) u0)        ;; Must have interests
                        (is-eq (len visited-places) u0)) ;; Must have travel experience
                    (err ERROR-YEARS-INVALID)  ;; Return error if validation fails
                    (begin
                        ;; Store the validated profile data
                        (map-set traveler-data user-id
                            {
                                username: username,
                                years: years,
                                hobbies: hobbies,
                                bucket-list: bucket-list,
                                visited-places: visited-places
                            }
                        )
                        (ok "Traveler profile successfully created.")  ;; Success message
                    )
                )
            )
            (err ERROR-RECORD-EXISTS)  ;; Cannot create duplicate profile
        )
    )
)

;; Public function - Modify an existing traveler profile
(define-public (modify-traveler
    (username (string-ascii 100))
    (years uint)
    (hobbies (list 10 (string-ascii 50)))
    (bucket-list (list 5 (string-ascii 100)))
    (visited-places (list 5 (string-ascii 100))))
    (let
        (
            (user-id tx-sender)  ;; Current user's blockchain address
            (existing-data (map-get? traveler-data user-id))  ;; Check if profile exists
        )
        ;; First check if profile exists
        (if (is-some existing-data)
            (begin
                ;; Validate all input parameters
                (if (or (is-eq username "")
                        (< years u18)                   ;; Must be adult
                        (> years u120)                  ;; Reasonable upper limit
                        (is-eq (len bucket-list) u0)    ;; Must have travel goals
                        (is-eq (len hobbies) u0)        ;; Must have interests
                        (is-eq (len visited-places) u0)) ;; Must have travel experience
                    (err ERROR-YEARS-INVALID)  ;; Return error if validation fails
                    (begin
                        ;; Update the existing profile data
                        (map-set traveler-data user-id
                            {
                                username: username,
                                years: years,
                                hobbies: hobbies,
                                bucket-list: bucket-list,
                                visited-places: visited-places
                            }
                        )
                        (ok "Traveler profile successfully updated.")  ;; Success message
                    )
                )
            )
            (err ERROR-NO-DATA-FOUND)  ;; Cannot update non-existent profile
        )
    )
)
