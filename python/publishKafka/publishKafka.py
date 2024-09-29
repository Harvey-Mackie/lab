
import json
import os

# Path to the topics.json file
TOPICS_FILE = 'topics.json'

def load_topics():
    """Load topics from the JSON file, or create it if it doesn't exist."""
    if not os.path.exists(TOPICS_FILE):
        # If the file doesn't exist, create it with an empty array
        with open(TOPICS_FILE, 'w') as f:
            json.dump({"topics": []}, f)
        return []
    
    # Load the topics from the file
    with open(TOPICS_FILE, 'r') as f:
        data = json.load(f)
        return data.get("topics", [])

def save_topics(topics):
    """Save the updated topics to the JSON file."""
    with open(TOPICS_FILE, 'w') as f:
        json.dump({"topics": topics}, f, indent=4)

def get_topic():
    """Prompt the user to select or enter a new topic."""
    topics = load_topics()
    
    print("Current topics:")
    for i, topic in enumerate(topics, start=1):
        print(f"{i}. {topic}")
    
    topic = input("\nEnter a topic (or new one if not listed): ").strip()

    # If the entered topic is new, add it to the list
    if topic not in topics:
        print(f"'{topic}' is not in the current list of topics.")
        if input(f"Do you want to add '{topic}' to the list? (y/n): ").lower() == 'y':
            topics.append(topic)
            save_topics(topics)
            print(f"'{topic}' has been added to the topics list.")
    
    return topic

def get_file_location():
    """Prompt the user to enter the file location."""
    file_location = input("Enter the file location: ").strip()
    if not os.path.exists(file_location):
        print(f"Error: The file '{file_location}' does not exist. Please try again.")
        return get_file_location()
    return file_location

def get_num_records():
    """Prompt the user to enter the number of records to process."""
    while True:
        try:
            num_records = int(input("Enter the number of records to process: "))
            return num_records
        except ValueError:
            print("Invalid input. Please enter a valid integer.")

def main():
    """Main function to process the Kafka records."""
    print("Welcome to Kafka Publisher")

    # Step 1: Get topic
    topic = get_topic()

    # Step 2: Get file location
    file_location = get_file_location()

    # Step 3: Get number of records
    num_records = get_num_records()

    # Display user inputs (this is where you'd integrate with your Kafka publisher)
    print(f"\nProcessing Kafka topic: {topic}")
    print(f"File location: {file_location}")
    print(f"Number of records to process: {num_records}")

    # Your Kafka publishing logic can go here, using the 'topic', 'file_location', and 'num_records' variables

if __name__ == "__main__":
    main()
