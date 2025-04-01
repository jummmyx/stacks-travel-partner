# Stacks Travel Partner - Traveler Profile Management System

Stacks Travel Partner is a decentralized application that enables travelers to manage their personal profiles on the Stacks blockchain. This system allows users to store their travel history, bucket list, hobbies, and more, in a secure and immutable way. The application ensures that traveler data is only accessible by the user and can be easily updated, fetched, and interacted with on the blockchain.

## Features

- **Create Traveler Profile**: Users can create their own travel profiles with personal details such as name, age, hobbies, and travel history.
- **Modify Traveler Profile**: Users can update their profile data anytime, including adding or removing bucket list destinations and visited places.
- **Fetch Traveler Information**: Easily retrieve details about a traveler, including their username, age, hobbies, bucket list, and places they've visited.
- **Error Handling**: The system provides detailed error messages for invalid data or missing profiles, ensuring a smooth user experience.

## Smart Contract Functions

### 1. `create-traveler`
Creates a new traveler profile on the blockchain. Requires:
- `username`: Traveler's display name.
- `years`: Traveler's age.
- `hobbies`: List of activities the traveler enjoys.
- `bucket-list`: List of destinations the traveler wants to visit.
- `visited-places`: List of places the traveler has already visited.

### 2. `modify-traveler`
Modifies an existing traveler profile with new details. Requires:
- Same parameters as `create-traveler`.

### 3. Read-Only Functions:
- `fetch-traveler-profile`: Retrieve the full profile of a traveler.
- `fetch-traveler-name`: Get the traveler’s name.
- `fetch-traveler-age`: Get the traveler’s age.
- `fetch-traveler-hobbies`: Get the traveler’s hobbies.
- `fetch-bucket-list`: Retrieve the list of destinations the traveler wants to visit.
- `fetch-visited-places`: Get the places the traveler has already visited.
- `fetch-profile-stats`: Get a summary of the traveler’s profile with counts of hobbies, bucket list, and visited places.

## Error Codes
The system provides several error codes for better user feedback:
- **ERROR-NO-DATA-FOUND**: No data found for the requested traveler.
- **ERROR-RECORD-EXISTS**: The profile already exists.
- **ERROR-YEARS-INVALID**: Invalid age (must be between 18 and 120).
- **ERROR-USERNAME-INVALID**: Invalid username.
- **ERROR-LOCATION-INVALID**: Invalid location (for bucket list or visited places).
- **ERROR-HOBBIES-INVALID**: Invalid hobbies (should not be empty).
- **ERROR-HISTORY-INVALID**: Invalid travel history (should not be empty).

## Requirements

- **Stacks Blockchain**: This application uses the Stacks blockchain for decentralized storage of traveler data.
- **Clarity Smart Contracts**: The system is built using Clarity, the language for writing smart contracts on the Stacks blockchain.

## Getting Started

### Prerequisites
- Install Stacks CLI for local development and deployment of Clarity contracts.
- Set up a Stacks wallet for interacting with the blockchain.

### Deploying the Contract
1. Clone the repository:
    ```bash
    git clone https://github.com/your-username/stacks-travel-partner.git
    ```
2. Deploy the contract on the Stacks network using the Stacks CLI.

### Interacting with the Contract
You can interact with the contract through the Stacks blockchain, either via a frontend or directly via smart contract calls.

## Contributing

We welcome contributions! If you’d like to contribute to this project:
1. Fork the repository.
2. Create a feature branch (`git checkout -b feature-name`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin feature-name`).
5. Create a new Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
