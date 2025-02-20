#!/bin/bash

# Prompt for user name
read -p "Enter your name: " userName
# Create main directory
teta="submission_reminder_${userName}"

# create directory structure
 mkdir -p "$teta/app"
 mkdir -p "$teta/modules"
 mkdir -p "$teta/assets"
 mkdir -p "$teta/config"

 #create necessary files 
 touch "$teta/app/reminder.sh"
 touch "$teta/modules/functions.sh"
 touch "$teta/assets/submissions.txt"
 touch "$teta/config/config.env"
 touch "$teta/startup.sh"
 touch "$teta/README.md"

 #assign config.env to main directory
 cat << EOF > "$teta/config/config.env"
 
 # This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

#assign submission.txt to main directory with student's examples records
 cat << EOF > "$teta/assets/submissions.txt"
 student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Muvunyi, Python, submitted
Jonathan, Shell Basics, Submitted
Ketsia,Database, Submitted
Laura,Git, Not submitted
Cappucci, C++, Not submitted
EOF

#assign functions.sh to main directory/sub_directory
cat << 'EOF' > "$teta/modules/functions.sh"
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

#assign reminder.sh to main directory/sub_directory 
cat << 'EOF' > "$teta/app/reminder.sh"
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"

echo "--------------------------------------------"

check_submissions $submissions_file
EOF

#assign startup.sh to main directory/sub_directory
cat << 'EOF' > "$teta/startup.sh"
#!/bin/bash

./app/reminder.sh
#execution message of reminder
echo "reminder executed successfully"
EOF


#permission for execution script

chmod +x "$teta/app/reminder.sh"
chmod +x "$teta/modules/functions.sh"
chmod +x "$teta/startup.sh"

echo "Setup completed!"
cd "$teta"
./startup.sh





